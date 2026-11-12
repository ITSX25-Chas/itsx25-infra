# Individuell slutrapport

**Namn:** Armin] 
**Projekt/team:** Team 5 
**Datum:** 2026-11-05

---

## Syfte och kursmål

I rapporten ska du sammanställa projektets resultat och dina egna reflektioner för en fiktiv ledningsgrupp. Du ska omsätta tekniskt säkerhetsarbete till mätbar uppföljning, förbättringsarbete och prioriterade rekommendationer. Du ska också värdera när AI är lämpligt eller olämpligt i professionellt säkerhetsarbete.

Rapporten knyter an till:

- **Kursmål 4:** säkerhetsmätningar, KPI:er och compliance-rapportering till ledningsnivå.
- **Kursmål 9:** incidentrespons, post-mortem och förbättringsarbete.
- **Kursmål 10:** KPI-rapportering för en icke-teknisk beslutsfattare.
- **Kursmål 11:** integrerad användning och professionell värdering av generativ AI och AI-assisterade säkerhetsverktyg.
- **Kursmål 13:** självständigt leda och leverera ett komplext säkerhetsprojekt med kvalitet, dokumentation och professionell kommunikation.

Bedömningen utgår från målgruppsanpassning, källanvändning, struktur, motivering och din förmåga att visa förståelse för helheten.

---

## 1. Professionell sammanfattning

Under kursen i avancerad IT-säkerhet har vi i Team 5 byggt, härdat och utvärderat en molninfrastruktur i Google Cloud Platform (GCP) samt genomfört praktiska penetrationstester och incidentanalyser. Denna slutrapport sammanställer våra viktigaste resultat, säkerhetsrisker och strategiska rekommendationer för organisationens ledning.

Projektets mest betydande resultat är att vi minimerat den externa attackytan genom fullständig nätverksisolering utan publika IP-adresser, infört automatiserad säkerhetsscanning i vår CI/CD-pipeline (GitHub Actions med Checkov och TFLint) samt sanerat bort överprivilegierade administratörsroller i molnet (Issue #10). Under penetrationstester mot en intern portal identifierade vi dock kritiska sårbarheter i form av en enkel SQL-injektion i inloggningen och okrypterade administratörskakor, vilket möjliggör full systemkompromettering på under en minut.

För att följa upp säkerhetsläget över tid rekommenderas tre konkreta KPI:er: åtgärdstid för sårbarheter inom SLA, andel godkända PR:er i CI utan säkerhetsavvikelser och graden av nätverksisolering. Dessa mätetal ger ledningen en snabb, icke-teknisk överblick över om vi hinner stänga kända risker och om vårt grundskydd håller tätt.

Mina viktigaste rekommendationer till ledningen är att omedelbart åtgärda inloggningskoden i portalen (P1), formellt fastställa en policy om noll publika IP-adresser för interna servrar (P1), kravställa OS Login och Shielded VM på samtliga molnmaskiner (P2), samt standardisera automatisk extern övervakning och isolerade testmiljöer i driften (P2). Dessa åtgärder ger organisationen en robust, mätbar och långsiktigt hållbar säkerhetsnivå.

---

## 2. Kontext och avgränsning

Rapporten utgår från det praktiska infrastruktur- och säkerhetsarbete som genomförts i Team 5 inom ramen för kursen Avancerad IT-säkerhet. Arbetet omfattar tre centrala delområden:
1. **Molninfrastruktur och IaC:** Driftsättning, nätverksisolering och härdning av virtuella servrar och Kubernetes i GCP med hjälp av Terraform (repot `itsx25-infra`).
2. **Penetrationstest och sårbarhetsanalys:** Testning av webbapplikationssäkerhet och behörighetskontroller mot en företagsportal (Acme Corp).
3. **Incidentrespons och post-mortem:** Teknisk analys och åtgärdsplan efter ett verkligt drift- och nätverksavbrott på vår Headscale-jumphost den 29 september.

Underlaget utgörs av projektets egna Terraform-moduler, GitHub Issues, byggloggar från GitHub Actions, penetrationstestprotokoll samt system- och seriekonsolloggar från GCP. Rapporten fokuserar på organisationens strategiska skydd, tillgänglighet och riskreducering.

---

## 3. Mitt individuella bidrag

I projektet har mitt fokus framför allt legat på att härda vår molnmiljö i GCP, tillämpa principen om minsta behörighet (Least Privilege) och dra organisatoriska lärdomar vid systemhaverier. Jag har drivit på för att säkerhetskrav ska realiseras direkt i vår infrastrukturkod (Terraform) och CI/CD-pipeline.

Mina viktigaste identifierbara insatser i Team 5:
- **Sanering av IAM i CI/CD-pipelinen (Issue #10):** Jag upptäckte att servicekontot för GitHub Actions hade den alldeles för breda rollen `roles/editor` på hela GCP-projektet. Jag avlägsnade denna och tilldelade strikt avgränsade roller för nätverk, instanser och skrivrättighet enbart till dess specifika state-bucket. Ändringen testades och rullades ut kontrollerat med en målinriktad driftsättning i Terraform så att ingen annan resurs i projektet påverkades.
- **Utfasning av SSH-metadata och införande av Shielded VM (Issue #12):** Jag analyserade riskerna med statiska SSH-nycklar i instansernas metadata och drev igenom övergång till Google OS Login via IAP samt krav på Shielded VM (Secure Boot, vTPM och integritetsövervakning).
- **Post-mortem efter Headscale-kraschen:** Jag var inte aktiv den 29 september när själva kraschen inträffade och teamet hanterade det akuta läget. Mitt bidrag har varit att i efterhand granska konsolloggarna, utreda diskkonflikten samt granska och verifiera de permanenta lösningarna: fstab med `nofail` (PR #127) och isolerad återställningsrutin (PR #130).
- **Penetrationstest mot Acme Corp:** Jag identifierade att autentiseringen kunde kringgås via SQL-injektion samt att administrationspanelen förlitade sig på okrypterade kakor.

I teamet har jag fungerat som en rådgivande länk mellan utveckling och drift, och stöttat kollegorna i att lösa säkerhetsavvikelser utan att stoppa utvecklingstakten.

---

## 4. Viktigaste projektresultat och evidens

### Resultat 1: Total nätverksisolering av interna resurser

#### Resultat
Vi har helt avlägsnat publika IP-adresser från organisationens interna servrar och klustertjänster. All administrativ styrning och intern driftstrafik sker uteslutande via krypterade tunnlar genom vårt Tailscale/Headscale-nätverk samt Google Cloud Identity-Aware Proxy (IAP).

#### Evidens
- Terraform-modulerna i repot `itsx25-infra` samt nätverksarkitekturen i `spectre-tailnet.md`.
- Verifiering genom extern portscanning som bekräftar noll öppna administrationsportar (SSH/RDP) mot publika internet.

#### Verksamhets- och säkerhetsbetydelse
Detta eliminerar organisationens externa attackyta mot automatiserade internetangrepp och sårbarhetsscanningar. Även om en sårbarhet skulle upptäckas i en intern tjänst eller ett driftverktyg kan den inte nås eller exploateras av utomstående angripare på internet.

#### Rekommendation
Ledningen (CISO och IT-infrastrukturansvarig) bör fastställa en officiell princip om att interna arbetslaster aldrig får tilldelas publika IP-adresser, vilket löpande övervakas via vårt mätetal för nätverksisolering (KPI 3).  
**Prioritet:** P1 (Strategisk baslinje).  
**Ägare:** Nätverks- och infrastrukturansvarig.

---

### Resultat 2: Slopade statiska SSH-nycklar till förmån för OS Login och Shielded VM

#### Resultat
Vi har påbörjat utfasningen av statiska SSH-nycklar lagrade i virtuella maskiners metadata och ersätter dem med centraliserad åtkomsthantering via Google OS Login knutet till IAM. Samtidigt specificeras att servrar körs som Shielded VM med Secure Boot, vTPM och integritetsövervakning.

#### Evidens
- Riskanalysen och åtgärdsplanen i `issue_12.md`.
- Compute Engine-konfigurationerna i Terraform (`itsx25-infra`).

#### Verksamhets- och säkerhetsbetydelse
Statiska SSH-nycklar skapar allvarliga administrationsrisker; när en medarbetare lämnar organisationen finns behörigheten ofta kvar på servrarna, och inloggningar loggas inte centralt. Med OS Login dras behörigheten tillbaka automatiskt via IAM, och varje inloggning loggas i Google Cloud Audit Logs. Shielded VM garanterar dessutom att systemets uppstart inte manipulerats av rootkits eller skadlig kod.

#### Rekommendation
Infrastrukturteamet bör implementera en GCP Organization Policy som förbjuder SSH-nycklar i metadata och tvingar på OS Login och Shielded VM som standard för alla framtida virtuella maskiner.  
**Prioritet:** P2 (Hög).  
**Ägare:** Cloud IAM- och säkerhetsansvarig.

---

### Resultat 3: Säkerhetsgranskning (DevSecOps) och IAM-härdning i CI/CD

#### Resultat
Vi har integrerat automatiserad säkerhetsscanning i vår GitHub Actions-pipeline (`pr-checks.yml`) med Checkov och TFLint. Parallellt har vi sanerat bort breda behörigheter (`roles/editor`) för pipelinens servicekonto och ersatt dessa med minsta nödvändiga rättigheter.

#### Evidens
- Pipelinedefinitionen i `.github/workflows/pr-checks.yml` och loggar från pull request-körningar.
- Åtgärdsdokumentationen i `issue_10.md` och Terraform IAM-definitionerna.

#### Verksamhets- och säkerhetsbetydelse
Automatiserade kontroller stoppar felaktiga konfigurationer (öppna brandväggar, okrypterade diskar eller överprivilegierade konton) direkt när koden skrivs ("shift-left"). Genom att samtidigt strikt begränsa pipelinens egna rättigheter elimineras risken att ett stulet token eller en komprometterad pipeline leder till att hela GCP-projektet tas över.

#### Rekommendation
Utvecklingsansvarig bör aktivera strikta branch protection rules i GitHub som blockerar all merge till `main` om Checkov eller TFLint rapporterar säkerhetsavvikelser.  
**Prioritet:** P2 (Hög).  
**Ägare:** Utvecklingsansvarig och DevOps-teamet.

---

## 5. KPI:er och ledningsrapportering

Från arbetet i [`kpi.md`](./kpi.md) har jag tagit fram tre konkreta mätetal som hjälper en icke-teknisk ledning att följa organisationens säkerhetsstatus utan att drunkna i tekniska detaljer:

1. **Åtgärdsgrad för kritiska och höga sårbarheter inom SLA (KPI 1):** Mäter hur stor andel av identifierade allvarliga sårbarheter som åtgärdas inom utsatt tid (max 7 dagar för kritiska, 14 dagar för höga). Det svarar för ledningen på: *"Låter vi kända sårbarheter stå öppna för länge?"*
2. **IaC-efterlevnad i CI/CD-pipelinen (KPI 2):** Mäter andelen pull requests i infrastrukturrepot som passerar automatiska säkerhetskontroller utan avvikelser. Det visar hur framgångsrika vi är på att stoppa felkonfigurationer innan koden driftsätts i molnet.
3. **Täckning av nätverksisolering (KPI 3):** Mäter andelen interna servrar och containrar som är helt dolda från publika internet och saknar extern IP. Svarar rakt på: *"Hur skyddade är våra interna system mot angrepp utifrån?"*

### Relevans och beslutsstöd för icke-tekniker
Mätetalen kombinerar tre kritiska dimensioner: reaktiv snabbhet (KPI 1), proaktiv kvalitet (KPI 2) och strukturell motståndskraft (KPI 3). För en ledningsgrupp ger detta ett tydligt beslutsstöd. Om KPI 2 ligger på 100 % medan KPI 1 faller under målvärdet (80–90 %), är det en signal om att teamet bygger rätt men inte har tid att hantera löpande sårbarheter. Ledningen kan då fatta ett affärsmässigt beslut att pausa nya funktioner och prioritera säkerhetsunderhåll.

### Begränsningar i data och tolkning
Mätetalen speglar uteslutande teknisk infrastruktur och kända registrerade ärenden. De visar inte organisationens exponering för social engineering (phishing), okända nolldagarsattacker eller sårbarheter hos externa leverantörer. Rapporteringen ska därför tolkas som en teknisk hälsokontroll som alltid bör kompletteras med utbildningsinsatser och penetrationstester.

---

## 6. Incidentrespons, post-mortem och förbättringsarbete

I [`lessons-learned.md`](./lessons-learned.md) har jag analyserat den allvarliga driftincident som inträffade den 29 september 2026, då teamets Headscale-jumphost kraschade och hela det interna tailnätet låg nere under flera timmar.

*Jag var själv inte aktiv den 29 september när kraschen skedde och teamet hanterade det akuta läget. Mitt arbete har bestått i att i efterhand genomföra en grundlig haverianalys utifrån loggar och utvärdera de permanenta åtgärder som vidtogs.*

### Händelseförlopp och orsak
Incidenten orsakades inte av ett yttre angrepp, utan uppstod till följd av ett internt återställningstest av säkerhetskopior dagen innan. En ansluten snapshotdisk med identiskt partitions-UUID lämnades kvar på servern. Vid omstart uppstod en diskkonflikt som fick Linux filsystemskontroll (`fsck`) att fela på `/boot/efi`, vilket fick systemd att avbryta bootprocessen och gå in i nödläge (*emergency mode*). På grund av brist på extern övervakning upptäcktes inte avbrottet automatiskt – i molnkonsolen stod maskinen felaktigt som frisk (*RUNNING*). När teamet försökte felsöka via seriekonsolen var man utelåst eftersom root-kontot var inaktiverat och nätverksbaserat OS Login inte fungerade när operativsystemet havererat.

### Genomförda förbättringar och uppföljning
1. **Oberoende extern övervakning (PR #128):** Google Cloud Uptime Checks verifierar nu Headscales hälsa varje minut från tre globala platser och larmar direkt vid avbrott.
2. **Feltolerant uppstartskonfiguration (PR #127):** Icke-kritiska partitioner i `/etc/fstab` monteras nu med flaggan `nofail`, vilket innebär att servrarna bootar felfritt även vid problem med sekundära diskar.
3. **Isolerade haveritester (PR #130):** Återställningstester av säkerhetskopior sker numera uteslutande i fristående, temporära testmaskiner utan kontakt med produktionsdiskar.

Organisationens viktigaste lärdom är att egna säkerhets- och backuptester aldrig får riskera driftsatta miljöer, samt att en verifierad nödväg in (*break-glass*) är helt nödvändig när nätverksautentisering slås ut.

---

## 7. AI i säkerhetsarbetet

Under projektets gång har jag aktivt använt generativa AI-assistenter, främst Claude och Gemini via terminal och editor, som en integrerad del av arbetsflödet. Verktygen har fungerat som effektiva hjälpmedel för att öka tempot, men erfarenheterna visar också tydligt var de tekniska och professionella gränserna går.

### Konkreta användningsfall
Jag har främst använt AI inom tre områden:
1. **Analys av felloggar:** Vid vårt post-mortem matade jag in långa utdrag från systemd- och seriekonsolloggar för att snabbare isolera varför Linux avbröt bootprocessen med *read-only filesystem* på `/boot/efi`.
2. **Kodskelett och syntax:** För att ta fram grundläggande mallar och syntax för Terraform-resurser (till exempel GCP Uptime Checks i `monitoring/`) samt YAML-steg i GitHub Actions.
3. **Strukturering och threat intelligence:** För att bolla relevanta MITRE ATT&CK-tekniker (exempelvis T1190 och T1078.004) och strukturera teknisk dokumentation.

### När AI var lämpligt
AI visade sig särskilt lämpligt för att snabbt tolka obskyra felmeddelanden och felsöka systemkomponenter. I stället för att manuellt leta igenom dokumentation och forum gav AI en omedelbar förklaring till varför systemd reagerar som den gör vid mount-fel. Detta sparade värdefull tid under haverianalysen. Det fungerade också utmärkt för syntaktiskt grovarbete och tabellstrukturering, där resultatet är enkelt att överblicka och inte medför direkta säkerhetsrisker.

### När AI var olämpligt eller otillräckligt
Där AI däremot visade sig olämpligt och direkt riskabelt var vid hantering av behörigheter och IAM i molnet. När jag bad om förslag på rättigheter för vårt CI/CD-servicekonto föreslog modellen upprepade gånger breda roller som `roles/editor` eller `compute.admin` med motiveringen att det "undviker behörighetsfel". AI tenderar att optimera för att systemet ska fungera friktionsfritt snarare än att upprätthålla principen om minsta behörighet. Att blint följa AI-förslag här hade bibehållit exakt den allvarliga sårbarhet som vi behövde åtgärda (Issue #10). AI är också helt olämpligt att använda med skarpa hemligheter, certifikat eller interna IP-planer av sekretess- och dataskyddsskäl.

### Verifiering och mänsklig kontroll
Jag tillämpade en strikt princip om att aldrig driftsätta AI-genererat material utan oberoende manuell kontroll:
- **Förhandsgranskning i Terraform:** All infrastrukturkod granskades noggrant genom planeringssteget mot förväntade ändringar före driftsättning.
- **Kontroll mot officiell dokumentation:** Alla föreslagna IAM-roller och Terraform-attribut dubbelkollades mot Googles officiella molndokumentation.
- **Praktisk provning:** Efter att `fstab` ändrats med `nofail` förlitade vi oss inte på modellens påståenden, utan genomförde kontrollerade omstarter av virtuella maskiner i GCP för att fysiskt verifiera beteendet.

### Risker och professionella gränser
Den största yrkesmässiga risken med AI är bekvämlighet och okritisk acceptans. Modeller hallucinerar ibland och hittar på icke-existerande argument eller ger förlegade säkerhetsråd som ser trovärdiga ut vid en första anblick. Dessutom finns en påtaglig risk för informationsläckage om känsliga konfigurationer eller systemspecifika detaljer matas in i publika molnmodeller.

### Professionell slutsats
AI är ett kraftfullt verktyg för att effektivisera felsökning, översätta loggar och producera kodmallar, men kan aldrig axla ett säkerhetsansvar. I en professionell roll måste ingenjören själv förstå varje enskild rad kod och konfiguration som produktionssätts. Grundregeln för framtida säkerhetsarbete är därför tydlig: använd AI för hastighet och idébollning, men tillämpa alltid manuell granskning, verifiera mot primärkällor och uteslut all känslig data från externa prompter.

---

## 8. Prioriterade rekommendationer

### Rekommendation 1: Åtgärda autentisering och SQL-injektion i internportalen
- **Vad:** Skriv om databasfrågorna i inloggningsmodulen till parametriserade frågor (`prepared statements`) och ersätt okrypterade kakor med säkra, kryptografiskt signerade sessions-ID:n på serversidan.
- **Varför:** En angripare kan kringgå inloggningen på under en minut med en enkel SQL-injektion (T1190) och ta administrativ kontroll över applikationen.
- **Risk/Möjlighet:** Eliminerar den mest akuta sårbarheten som hotar interna data och underliggande servrar.
- **Prioritet:** **P1 (Kritisk – åtgärdas omedelbart)**.
- **Ägare:** Applikationsteamet och ansvarig utvecklare.

### Rekommendation 2: Formellt beslut om noll publika IP-adresser för interna system
- **Vad:** Fastställ en tvingande organisationspolicy om att interna servrar och databaser aldrig får exponeras med publika IP-adresser. Åtkomst ska uteslutande ske via Tailscale/Headscale och Google IAP.
- **Varför:** Tar bort interna system från publika internet och förhindrar scanningar och obehöriga anslutningsförsök.
- **Risk/Möjlighet:** Minimerar organisationens attackyta mot automatiserade externa angrepp.
- **Prioritet:** **P1 (Hög / Strategisk baslinje)**.
- **Ägare:** CISO och nätverksansvarig.

### Rekommendation 3: Kravställ Google OS Login och Shielded VM på alla molnservrar
- **Vad:** Aktivera en GCP Organization Policy som förbjuder statiska SSH-nycklar i instansmetadata och kräver Shielded VM (Secure Boot, vTPM och integritetsövervakning).
- **Varför:** Eliminerar kvarlämnade nycklar när personal slutar, säkerställer centraliserad spårbarhet i Cloud Audit Logs och skyddar bootprocessen mot manipulering.
- **Risk/Möjlighet:** Minskar risken för orättmätig access och obemärkta behörighetsläckor.
- **Prioritet:** **P2 (Hög)**.
- **Ägare:** Cloud IAM- och infrastrukturansvarig.

### Rekommendation 4: Automatisera extern uptime-larmning och isolera haveritester
- **Vad:** Rulla ut externa hälsokontroller (Uptime Checks) på alla kritiska verksamhetstjänster och kravställ att tester av säkerhetskopior enbart får ske i temporära, frånkopplade testmiljöer.
- **Varför:** Säkerställer att avbrott upptäcks omedelbart och eliminerar risken att interna tester sänker driftmiljön så som inträffade den 29 september.
- **Risk/Möjlighet:** Höjer organisationens driftsäkerhet, larmberedskap och SLA-efterlevnad.
- **Prioritet:** **P2 (Hög)**.
- **Ägare:** Driftansvarig / SRE.

---

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?
Innan kursen såg jag ofta cybersäkerhet som separata tekniska öar – brandväggar för sig, kodbuggar för sig och molnrättigheter för sig. Idag förstår jag hur hela kedjan hänger ihop i en modern molnmiljö. Jag kan självständigt navigera i ett komplext GCP-projekt med Terraform, identifiera när ett servicekonto i GitHub Actions har för vida rättigheter, och analysera hur en liten brist i en pipeline i kombination med en webbsårbarhet kan leda till full eskalering. Jag har också lärt mig att kartlägga hot mot MITRE ATT&CK och kommunicera tekniska risker så att icke-tekniska beslutsfattare förstår innebörden.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?
Det var tveklöst arbetet med vårt post-mortem efter haveriet den 29 september. Att i detalj analysera hur ett helt legitimt internt säkerhetstest (att verifiera återställning av backuper) kunde orsaka en diskkonflikt som försatte Linux i emergency mode och låste ut oss från konsolen var en ögonöppnare. Det förändrade min syn i grunden: säkerhet handlar inte bara om att bygga ogenomträngliga murar mot externa angripare, utan minst lika mycket om systemtillgänglighet, feltolerans och att inte skapa skyddsåtgärder som slår ut den egna driften.

### Vad skulle jag göra annorlunda om projektet började idag?
Om jag startade om projektet idag skulle jag införa principen om minsta behörighet (Least Privilege) och automatiserad linting från dag ett. I projektets inledning delades breda rättigheter som `roles/editor` ut för att snabbt komma igång, vilket krävde onödig tid för att sanera i efterhand. Jag skulle också se till att automatiserad extern uptime-övervakning och en testad nödväg in (*break-glass*) fanns på plats innan servrar låstes ner och nätverksåtkomsten begränsades.

### Vad tar jag med mig till LIA och min framtida yrkesroll?
1. **Automatisera säkerhet tidigt (Shift-Left):** Jag kommer konsekvent att verka för att integrera säkerhetskontroller som Checkov och sårbarhetsscanning direkt i CI/CD-pipelinen. Att fånga felkonfigurationer i en pull request sparar enorma resurser jämfört med akut felsökning i produktion.
2. **Översätta säkerhet till verksamhetsnytta:** Jag tar med mig förmågan att förklara tekniska säkerhetsfrågor med hjälp av begripliga mätetal och affärsmässiga risker.
3. **Ett sunt kritiskt tänkande:** Oavsett om det rör sig om en grön statuslampa i molnkonsolen eller ett kodförslag från en AI-assistent, tar jag med mig vanan att alltid granska kritiskt och verifiera mot hårda fakta innan beslut fattas.

---

## 10. Källor och referenser

### Standarder och ramverk
- **MITRE ATT&CK:** Enterprise Matrix v15. Taktiker: Initial Access (TA0001), Privilege Escalation (TA0004), Defense Evasion (TA0005). Tekniker: Exploit Public-Facing Application (T1190), Valid Accounts: Cloud Accounts (T1078.004).
- **CIS Benchmarks:** CIS Google Cloud Computing Foundations Benchmark v3.0 (rekommendationer rörande minsta behörighet och separation of duties för servicekonton).
- **OWASP:** Top 10 Web Application Security Risks (A01 Broken Access Control, A03 Injection).
- **FIRST:** Traffic Light Protocol (TLP) Standard v2.0.

### Projektartefakter och intern evidens
- `itsx25-infra`: Terraform-konfigurationer, moduler och PR-historik (PR #127, PR #128, PR #130).
- `issue_10.md` & `solution_issue10.md`: Genomförande av IAM-härdning för CI/CD-pipeline.
- `issue_12.md`: Riskanalys av SSH-nycklar i metadata och införande av Shielded VM/OS Login.
- `labb-pentest-anteckning.md`: Testloggar och verifiering från penetrationstestet mot internportalen.
- `kpi-3.md`: Fullständiga definitioner och beräkningar för säkerhets-KPI:er.
- `lessons-learned-3.md`: Fullständig post-mortem-analys av driftincidenten den 29 september.

### AI-användning
- Generativa AI-modeller (Claude och Gemini via CLI/terminal) har använts för tolkning av systemd-loggar, kodskelett och dokumentationsstruktur. Allt material har verifierats manuellt mot primärkällor och ändringsplaner i Terraform.

---

## Slutkontroll

- [x] Jag har tydligt beskrivit mitt eget bidrag och länkat till relevant underlag.
- [x] Mina viktigaste resultat stöds av evidens och källor.
- [x] Mina KPI:er är anpassade för en icke-teknisk beslutsfattare.
- [x] Mitt post-mortem leder till konkreta förbättringar och uppföljning.
- [x] Jag har beskrivit konkret AI-användning och självständigt värderat när AI är lämpligt eller olämpligt.
- [x] Jag har beskrivit hur AI-genererade resultat verifierades.
- [x] Mina rekommendationer följer av analysen och är prioriterade.
- [x] Den professionella sammanfattningen fungerar fristående.
- [x] Min individuella reflektion innehåller konkreta exempel.
- [x] Källor, länkar och referenser fungerar.
- [x] Inga lösenord, tokens, API-nycklar, personuppgifter eller andra skyddsvärda uppgifter finns i repositoryt.
- [x] Alla ändringar är committade och pushade till GitHub.
