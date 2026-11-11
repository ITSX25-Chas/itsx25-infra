# Post-mortem, lessons learned och professionell sammanfattning

## Syfte och kursmål

I den här delen ska du genomföra ett kort post-mortem över ett verkligt eller simulerat intrångsförsök i projektet. Du ska identifiera tre viktiga lärdomar och omsätta projektets resultat till information för en professionell mottagare.

Arbetet knyter an till:

- **Kursmål 9:** utföra incidentrespons, post-mortem och förbättringsarbete efter ett verkligt eller simulerat intrångsförsök.
- **Kursmål 13:** självständigt leda och leverera ett komplext säkerhetsprojekt med höga krav på kvalitet, dokumentation och professionell kommunikation.

En lesson learned är inte bara något som gick bra eller dåligt. Den ska visa vad som hände, varför det hände, vilken betydelse det fick och hur framtida säkerhetsarbete kan förbättras.

---

## Händelse och avgränsning

Detta post-mortem analyserar den allvarliga drift- och tillgänglighetsincident som drabbade Team 5 den 29 september 2026. Händelsen slog ut vår virtuella jumphost och vårt interna Headscale-tailnät, vilket innebar att all säker administration och nätverkstrafik till molnmiljön i Google Cloud Platform (GCP) blev totalt oåtkomlig.

Incidenten upptäcktes manuellt av teamet på morgonen när SSH och interna tjänster inte svarade, trots att GCP Console felaktigt visade maskinen som *RUNNING* med grön bock. I själva verket hade operativsystemet fastnat i Linux *emergency mode* under uppstarten.

Jag var själv inte aktiv den 29 september när kraschen inträffade och det akuta läget hanterades av teamet. Min roll har i stället varit att i efterhand genomföra post-mortem-analysen: granska seriekonsolens loggar, utreda bakomliggande systemorsaker samt granska och verifiera de permanenta skyddsåtgärder som togs fram i teamets Terraform-moduler och driftkonfigurationer.

---

## Lesson learned 1

### Observation
GCP Console visade att den virtuella maskinen var igång (*RUNNING* med grön bock), men webbadressen till Headscale gav HTTP 502 och SSH-åtkomst via Google IAP vägrade svara. Maskinen var en "zombie" som fastnat under uppstarten. Eftersom extern övervakning saknades tog det flera timmar innan avbrottet upptäcktes manuellt av teamet.

### Orsak
Teamet förlitade sig för mycket på molnleverantörens grundläggande infrastrukturstatus. Att en virtuell hårdvaruinstans körs och har ström innebär inte att operativsystemet bootat klart eller att applikationstjänsterna fungerar och svarar på anrop.

### Konsekvens
Ett totalt nätverks- och tillgänglighetsavbrott pågick under flera timmar utan att teamet eller ledningen fick något larm. I en skarp produktionsmiljö med kunder hade detta inneburit ett allvarligt brott mot organisationens tillgänglighetskrav (SLA).

### Förbättring
Teamet byggde en helt separat övervakningsmodul i Terraform (`monitoring/`, PR #128). Den sätter upp en Google Cloud Uptime Check som verifierar Headscales `/health`-endpoint varje minut från tre oberoende geografiska platser. Om tjänsten inte svarar med HTTP 200 skickas automatiska larm omedelbart via e-post och chatt.

### Uppföljning
Larmkedjan verifierades i skarpt läge genom att kontrollerat stänga ner Headscale under fem minuter. Samtliga tre kontrollpunkter genererade incidentlarm inom fastställd tid och skickade därefter en återställningsnotis så fort tjänsten startades om.

---

## Lesson learned 2

### Observation
Jumphosten kraschade under uppstarten på grund av att filsystemskontrollen (`fsck`) misslyckades med felmeddelandet *Read-only file system* på monteringspunkten `/boot/efi`. Detta fick Linux *systemd* att avbryta hela bootprocessen och gå in i nödläge (*emergency mode*).

### Orsak
Dagen innan hade teamet genomfört ett manuellt återställningstest av Headscale-databasens säkerhetskopior. En snapshot av bootdisken hade kopplats in till jumphosten men glömts kvar ansluten. Eftersom den hade identiska UUID:n och partitions-ID:n försökte maskinen montera fel EFI-partition vid omstart.

### Konsekvens
Ett internt säkerhetstest – som syftade till att verifiera att vi kunde återställa data – blev själva orsaken till att hela driftmiljön slogs ut.

### Förbättring
Teamet genomförde två permanenta förändringar:
1. Konfigurationsfilen `/etc/fstab` uppdaterades på alla servrar (PR #127) med parametern `nofail` och en timeout på 5 sekunder, vilket gör att maskinen fortsätter boota även om en sekundär partition krånglar.
2. En strikt och isolerad återställningsrutin infördes (PR #130). Återställningstester får aldrig mer utföras på aktiva driftmaskiner, utan körs enbart i temporära, helt fristående test-VM:ar där diskar monteras strikt via unika disk-ID:n (`by-id`).

### Uppföljning
Fstab-ändringarna provades med riktiga omstarter i GCP på både jumphost och primärnod för att verifiera att systemet bootade upp rent utan felande enheter. Därefter kördes den isolerade återställningsrutinen igenom för att bevisa att backupdata gick att läsa felfritt utan kontakt med driftsatta diskar.

---

## Lesson learned 3

### Observation
När jumphosten fastnade i nödläge försökte teamet ansluta via Google Cloud Serial Console för att rädda maskinen, men möttes av en inloggningsprompt som inte gick att använda eftersom kontot `root` var låst.

### Orsak
Som en del av OS-härdningen hade lösenordsinloggning för root inaktiverats och maskinen förlitade sig helt på Google OS Login över nätverket (IAP). Men när operativsystemet inte slutför uppstarten startar inte nätverksstacken eller systemd-tjänsterna för OS Login. Utan fungerande nätverk och utan ett lokalt lösenord blev seriekonsolen helt obrukbar.

### Konsekvens
Teamet kunde inte felsöka inifrån maskinen under de första kritiska minuterna. Hade inte felet kunnat identifieras utifrån via de loggar seriekonsolen spottade ur sig, hade teamet tvingats kassera hela maskinen och bygga upp den på nytt från scratch.

### Förbättring
Incidenten visade att nätverksberoende autentisering (som OS Login) alltid kräver en planerad nödväg in (*break-glass*). Teamet dokumenterade och standardiserade en procedur för hur man säkert räddar en låst maskin via GCP API (genom att koppla bootdisken till en tillfällig räddningsmaskin), utan att kompromissa med grundprincipen att hålla root-lösenord inaktiverade under normal drift.

### Uppföljning
Proceduren har dokumenterats i driftmanualen som en standardiserad haverirutin. Teamet säkerställde genom en praktisk genomgång att alla känner till hur diskar kopplas och redigeras via GCP CLI om en server slutar svara på nätverksinloggning.

---

## Professionell sammanfattning

Ett fullständigt drift- och nätverksavbrott drabbade Team 5 den 29 september 2026 när vår interna Headscale-jumphost kraschade under uppstart. Eftersom nätverket utgör organisationens enda säkra kommunikationskanal för administration och klusterstyrning slogs all åtkomst till miljön ut i flera timmar.

**Resultat och orsak:**
Händelsen orsakades inte av ett yttre cyberangrepp, utan av interna handhavandebrister under ett manuellt återställningstest av säkerhetskopior. En ansluten snapshotdisk med identiskt partitions-UUID lämnades kvar på servern, vilket fick filsystemskontrollen (`fsck`) på EFI-partitionen att fela och tvingade Linux in i nödläge (*emergency mode*). Incidenten blottade tre allvarliga risker: falsk trygghet i molnleverantörens övergripande statusvisning (som visade maskinen som frisk trots att den var stendöd), brist på automatisk extern larmning, samt att låsta administratörskonton i kombination med nätverksberoende OS Login helt utelåste teknikerna från felsökning via seriekonsolen.

**Rekommendation och prioriterade åtgärder:**
Teamet har genomfört tre permanenta förbättringar som omedelbart höjt driftsäkerheten:
1. Automatiserade externa hälsokontroller (Google Cloud Uptime Checks, PR #128) som verifierar Headscale varje minut från tre globala regioner och larmar direkt vid avbrott.
2. Feltolerant uppstartskonfiguration (PR #127) där parametern `nofail` i `fstab` hindrar icke-kritiska partitioner från att avbryta bootprocessen.
3. En strikt procedur för isolerade backuptester (PR #130) som säkerställer att återställningstester uteslutande genomförs i temporära, frånkopplade testmaskiner.

Ledningen rekommenderas att formellt besluta om en obligatorisk nödåtkomstprocedur (*break-glass*) för samtliga molnservrar, samt kräva att alla kritiska verksamhetstjänster omfattas av oberoende extern larmning med fastställda SLA:er.

---

## Kontroll före commit

- [x] Jag har avgränsat vilket intrångsförsök eller vilken incident mitt post-mortem gäller.
- [x] Jag har beskrivit min egen roll i incidentresponsen.
- [x] Jag har formulerat tre tydliga lessons learned.
- [x] Jag skiljer på observation och bakomliggande orsak.
- [x] Jag beskriver konsekvensen av varje lärdom.
- [x] Varje lesson learned leder till en konkret förbättring och uppföljning.
- [x] Den professionella sammanfattningen fokuserar på resultat, risk och betydelse.
- [x] Texten är begriplig utan alla tekniska detaljer från projektet.
