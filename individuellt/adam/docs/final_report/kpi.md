## KPI 1

### Namn
Andel kritiska och höga sårbarheter som åtgärdas inom fastställd SLA-tid.

### Syfte och mottagare
- **Mottagare:** CISO, IT-chef och produktägare.
- **Syfte:** Syftet med denna KPI är att ge ledningen en tydlig bild av hur effektivt organisationen arbetar med att identifiera, prioritera och åtgärda säkerhetsbrister. Genom att mäta hur stor andel av de allvarliga sårbarheterna som åtgärdas inom den bestämda tidsgränsen kan vi se om säkerhetsarbetet håller en tillräckligt hög nivå.

  Måttet är särskilt viktigt eftersom kritiska och höga sårbarheter kan innebära stora risker för organisationen. Om sådana brister lämnas ouppdaterade under en längre period kan de utnyttjas av angripare för att få obehörig åtkomst, stjäla information eller påverka systemens funktion.

  KPI:n hjälper även ledningen att upptäcka om organisationen börjar bygga upp en säkerhetsskuld, vilket innebär att det finns fler kända säkerhetsproblem än vad teamet hinner åtgärda. För en person utan teknisk bakgrund kan måttet sammanfattas med frågan: *"Hur länge låter vi kända säkerhetsrisker finnas kvar innan vi gör något åt dem?"*

### Definition och beräkning
KPI:n mäter andelen kritiska och höga sårbarheter som har åtgärdats och driftsatts inom organisationens fastställda SLA-tider (Service Level Agreement). Det innebär att det inte räcker att en utvecklare har påbörjat en åtgärd eller skapat en pull request. Själva lösningen måste vara färdig och finnas i produktionsmiljön för att räknas som åtgärdad.

För kritiska sårbarheter gäller en maximal åtgärdstid på 7 dagar, medan höga sårbarheter ska åtgärdas inom högst 14 dagar. Dessa tidsgränser gör det möjligt att prioritera arbetet utifrån hur stor risk varje sårbarhet innebär.

Beräkning: (Antal kritiska och höga sårbarheter som åtgärdats inom SLA / Totalt antal upptäckta kritiska och höga sårbarheter under perioden) × 100

Ett exempel är att om organisationen upptäcker 20 kritiska och höga sårbarheter under en månad och 18 av dessa åtgärdas inom respektive SLA, blir resultatet 90 %. Det innebär att organisationen uppnår en hög åtgärdsgrad, men att det fortfarande finns brister i hur snabbt alla säkerhetsproblem hanteras.

### Datakälla och datakvalitet
- **Datakälla:** GitHub Issues och automatiska säkerhetsskanningar i repot (`itsx25-infra`). Dessa används för att registrera upptäckta sårbarheter, följa deras status och kontrollera när de har åtgärdats.
- **Begränsningar:** Resultatets kvalitet är beroende av att samtliga upptäckta sårbarheter registreras korrekt och att information om upptäcktsdatum, allvarlighetsgrad och åtgärdsdatum finns tillgänglig. Om vissa säkerhetsbrister inte registreras kan resultatet ge en missvisande bild av organisationens säkerhetsarbete.

  En annan begränsning är att måttet inte tar hänsyn till hur komplicerad en åtgärd är. En enkel uppdatering av ett programbibliotek kan ta några minuter, medan en större säkerhetsbrist kan kräva omfattande förändringar i systemarkitekturen. KPI:n tar inte heller hänsyn till om tillfälliga skyddsåtgärder har införts under tiden, exempelvis regler i en WAF (Web Application Firewall) som begränsar möjligheten att utnyttja sårbarheten.

### Målvärde eller önskad riktning
- **Målvärde:** Minst 95 % för kritiska sårbarheter och minst 90 % för höga sårbarheter.
- **Akutgräns:** Kritiska sårbarheter med en känd exploit eller möjlighet till direkt kodkörning (RCE) ska hanteras inom 48 timmar.

  Målet är att organisationen ska kunna hantera nästan alla allvarliga säkerhetsbrister inom den uppsatta tidsramen. Ett högt resultat visar att säkerhetsarbetet är en naturlig del av utvecklingsprocessen och att det finns tillräckligt med resurser för att hantera risker.

  Om resultatet börjar sjunka under flera mätperioder kan det vara ett tecken på att arbetsbelastningen är för hög, att prioriteringarna behöver ändras eller att det behövs mer resurser till säkerhetsarbetet.

### Mätfrekvens
Resultatet sammanställs varje månad och rapporteras till ledningen för att ge en övergripande bild av hur organisationen hanterar sina säkerhetsbrister. Utöver detta gör teamet en veckovis uppföljning för att kontrollera vilka sårbarheter som fortfarande är öppna och om några riskerar att överskrida sina SLA-tider.

Den veckovisa uppföljningen gör det möjligt att agera innan en sårbarhet blir försenad, medan den månatliga rapporteringen hjälper ledningen att identifiera långsiktiga trender.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (över 90–95 %):** Visar att organisationen har god kontroll över sina säkerhetsbrister och att teamet lyckas åtgärda de flesta allvarliga sårbarheterna inom utsatt tid. Det innebär att risken för att kända sårbarheter ska hinna utnyttjas minskar.
- **Dåligt värde (under 80 %):** Kan tyda på att teamet har för hög arbetsbelastning, att säkerhetsarbetet inte prioriteras tillräckligt eller att det saknas resurser för att hantera identifierade problem. Om detta fortsätter kan organisationen bygga upp en större säkerhetsskuld.
- **Åtgärd:** Om resultatet hamnar under målvärdet bör ledningen tillsammans med produktägaren undersöka varför sårbarheterna inte åtgärdas inom tidsgränserna. Det kan exempelvis handla om brist på utvecklarresurser eller att nya funktioner prioriteras framför säkerhetsarbete.

  En möjlig åtgärd är att tillfälligt pausa eller minska utvecklingen av nya funktioner under nästa sprint och i stället avsätta resurser för att åtgärda befintliga säkerhetsproblem. Kritiska sårbarheter med hög exploateringsrisk ska alltid prioriteras först.

---

## KPI 2

### Namn
Andel infrastrukturändringar som godkänns av CI-kontroller utan säkerhetsbrister (IaC Compliance).

### Syfte och mottagare
- **Mottagare:** IT-chef och utvecklingsansvarig.
- **Syfte:** Denna KPI ska visa hur effektivt organisationen arbetar med att förebygga säkerhetsproblem redan under utvecklingsprocessen. Genom att använda automatiserade säkerhetskontroller kan felaktiga och osäkra konfigurationer upptäckas innan de når produktionsmiljön.

  Det kan exempelvis handla om att en utvecklare råkar öppna en brandvägg för allmän åtkomst, skapar en publik lagringsyta eller ger en användare för omfattande behörigheter genom IAM (Identity and Access Management). Sådana misstag kan skapa stora säkerhetsrisker om de inte upptäcks i tid.

  KPI:n visar därför hur bra våra förebyggande säkerhetsåtgärder fungerar. I stället för att vänta tills ett problem uppstår i den driftsatta miljön försöker vi stoppa säkerhetsbrister redan när infrastrukturen utvecklas och granskas.

  För ledningen innebär detta ett sätt att se om organisationen lyckas bygga in säkerhet i sina vanliga arbetsprocesser, snarare än att enbart förlita sig på manuella kontroller i efterhand.

### Definition och beräkning
KPI:n mäter andelen pull requests i infrastrukturrepot (`itsx25-infra`) som klarar de automatiska säkerhetskontrollerna Checkov och TFLint i GitHub Actions utan allvarliga regelbrott innan de mergas till `main`.

Checkov används för att analysera infrastrukturkonfigurationer och identifiera vanliga säkerhetsproblem, exempelvis felaktiga behörigheter eller resurser som exponeras publikt. TFLint används för att kontrollera Terraform-kod och upptäcka fel och problem i konfigurationen.

Genom att dessa verktyg körs automatiskt vid varje pull request får organisationen en återkommande kontroll av infrastrukturen. Det minskar risken för att mänskliga misstag eller felaktiga inställningar följer med när ändringar slås samman.

Beräkning: (Antal mergade pull requests utan säkerhetsavvikelser / Totalt antal mergade pull requests i itsx25-infra) × 100

Ett exempel är att om 25 pull requests mergas under en månad och samtliga passerar säkerhetskontrollerna utan allvarliga avvikelser blir resultatet 100 %. Om endast 23 av dessa klarar kontrollerna blir resultatet 92 %.

### Datakälla och datakvalitet
- **Datakälla:** Loggar från bygg- och kontrollprocessen `pr-checks.yml` i GitHub Actions. Där registreras resultatet från de automatiska kontrollerna som körs när en pull request skapas eller uppdateras.
- **Begränsningar:** Eftersom kontrollerna genomförs automatiskt är datan relativt objektiv och tillförlitlig. Resultatet påverkas inte av personliga bedömningar på samma sätt som vid manuella granskningar.

  En begränsning är däremot att verktygen endast kan upptäcka de typer av problem som deras regler är utformade för att identifiera. Om det finns ett mer avancerat designfel eller en felaktig systemlösning som inte omfattas av befintliga regler kan ändringen fortfarande godkännas.

  Ett högt resultat betyder därför inte automatiskt att infrastrukturen är helt säker. Det visar framför allt att våra automatiska kontroller fungerar enligt de regler som har konfigurerats.

### Målvärde eller önskad riktning
- **Målvärde:** 100 %. Alla infrastrukturändringar som innehåller allvarliga säkerhetsavvikelser ska stoppas innan de når `main`.

  Målet är att inga osäkra infrastrukturändringar ska kunna passera våra automatiska kontroller. Genom att ha ett mål på 100 % skapas en tydlig säkerhetsnivå som alla utvecklare måste följa.

  Det innebär även att eventuella undantag från säkerhetsreglerna måste granskas och dokumenteras. På så sätt undviker vi att säkerhetskontroller kringgås utan att det finns en tydlig anledning.

### Mätfrekvens
KPI:n följs upp månadsvis och omfattar alla pull requests som har mergats under perioden. Genom att sammanställa resultaten över tid kan organisationen se om antalet säkerhetsavvikelser minskar och om de automatiska kontrollerna fungerar som förväntat.

Resultatet kan även användas för att identifiera återkommande problem i utvecklingsprocessen. Om samma typ av säkerhetsbrist dyker upp vid flera tillfällen kan det vara ett tecken på att utvecklarna behöver tydligare riktlinjer eller ytterligare automatiska kontroller.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Visar att de automatiska säkerhetskontrollerna fungerar och att inga mergade infrastrukturändringar har innehållit identifierade allvarliga säkerhetsavvikelser. Det innebär att organisationen har ett fungerande förebyggande skydd i utvecklingsprocessen.
- **Dåligt värde (under 100 %):** Kan innebära att en osäker ändring har kommit in i `main`, exempelvis genom att branch protection har kringgåtts, att en merge har forcerats eller att det finns felaktiga undantag i säkerhetskontrollerna.
- **Åtgärd:** Om resultatet understiger 100 % ska den berörda pull requesten identifieras och granskas omedelbart. Om ändringen innebär en faktisk säkerhetsrisk bör den återställas eller korrigeras innan den används vidare.

  Därefter bör organisationen undersöka hur ändringen kunde passera kontrollerna. Det kan exempelvis innebära att se över inställningarna för branch protection, administratörsbehörigheter och reglerna i Checkov och TFLint.

  Om problemet beror på att en viss typ av säkerhetsbrist inte upptäcks av verktygen bör nya kontrollregler införas för att minska risken för att samma problem uppstår igen.

---

## KPI 3

### Namn
Andel interna resurser som har kontrollerad och verifierad nätverksisolering (Attack Surface Index).

### Syfte och mottagare
- **Mottagare:** CISO och IT-infrastrukturansvarig.
- **Syfte:** Syftet med denna KPI är att visa hur väl organisationen skyddar sina interna system från obehörig åtkomst via det publika internet. Genom att mäta hur stor andel av de interna resurserna som har korrekt nätverksisolering får ledningen en tydligare bild av organisationens externa attackyta.

  En intern server eller databas som av misstag exponeras med en publik IP-adress kan bli tillgänglig för angripare som försöker identifiera och utnyttja säkerhetsbrister. Därför är det viktigt att interna resurser endast kan nås genom godkända och kontrollerade åtkomstvägar.

  KPI:n hjälper organisationen att kontrollera att interna system inte är direkt tillgängliga från internet och att åtkomst i stället sker genom exempelvis Google IAP eller vårt Headscale-tailnät. Den säkerställer även att nätverkspolicies används för att begränsa kommunikationen mellan olika arbetslaster i Kubernetes.

  För ledningen besvarar måttet en viktig fråga: *"Hur stor del av våra interna system är skyddade från direkt åtkomst via internet?"*

### Definition och beräkning
KPI:n mäter andelen interna servrar, containrar och tjänster som uppfyller organisationens krav på nätverksisolering.

För att en resurs ska räknas som korrekt isolerad måste den uppfylla följande krav:

- Den får inte ha någon publik IP-adress som gör den direkt åtkomlig från internet.
- Åtkomst ska endast ske via godkända lösningar, exempelvis Google IAP eller organisationens Headscale-tailnät.
- Kubernetes-poddar ska skyddas av aktiva NetworkPolicies som begränsar vilken nätverkstrafik som tillåts mellan olika resurser.

Genom att kontrollera dessa delar kan organisationen minska risken för att angripare får direkt åtkomst till interna system. Det blir även enklare att upptäcka felkonfigurationer som annars skulle kunna skapa onödiga säkerhetsrisker.

Beräkning: (Antal interna arbetslaster med verifierad nätverksisolering / Totalt antal driftsatta interna arbetslaster) × 100

Ett exempel är att organisationen har 50 driftsatta interna resurser och att 48 av dessa uppfyller samtliga krav på nätverksisolering. Resultatet blir då 96 %. De två resurser som inte uppfyller kraven behöver undersökas och åtgärdas.

### Datakälla och datakvalitet
- **Datakälla:** Terraform State, GCP Console API och information om aktiva nätverkspolicies i Kubernetes-klustret. Dessa källor används för att kontrollera vilka resurser som är driftsatta, om de har publika IP-adresser och om de omfattas av rätt nätverksregler.

  Genom att använda flera datakällor kan organisationen få en mer komplett bild av nätverksmiljön. Terraform State visar hur infrastrukturen är definierad och hanteras, medan GCP API kan användas för att kontrollera den faktiska konfigurationen i molnmiljön. Kubernetes ger information om vilka nätverkspolicies som är aktiva i klustret.

- **Begränsningar:** Datakvaliteten är beroende av att samtliga driftsatta resurser finns med i inventeringen och att informationen från de olika systemen är uppdaterad. Om en resurs skapas manuellt utanför Terraform kan den exempelvis missas om inventeringen inte även kontrollerar den faktiska molnmiljön.

  En annan begränsning är att det inte räcker att en NetworkPolicy finns konfigurerad. Den måste även vara aktiv och fungera som avsett. Därför behöver kontrollerna verifiera den faktiska nätverksisoleringen och inte enbart förekomsten av konfigurationsfiler.

### Målvärde eller önskad riktning
- **Målvärde:** 100 % av alla interna arbetslaster ska uppfylla kraven för nätverksisolering.
- **Gränsvärde:** Om en intern server eller databas av misstag får en publik IP-adress ska detta betraktas som en allvarlig säkerhetsavvikelse som måste hanteras omedelbart.

  Målet är att minimera organisationens externa attackyta så mycket som möjligt. Genom att hålla interna system isolerade minskar risken för att obehöriga ska kunna identifiera, skanna eller ansluta till resurser som inte är avsedda att vara publikt tillgängliga.

  Ett målvärde på 100 % innebär att samtliga interna resurser ska uppfylla samma grundläggande säkerhetskrav, oavsett vilken funktion de har eller var de är driftsatta.

### Mätfrekvens
Resultatet sammanställs kvartalsvis och rapporteras till ledningen. Utöver den regelbundna rapporteringen ska automatiska kontroller genomföras vid varje ny driftsättning eller förändring av infrastrukturen.

Detta gör att eventuella felkonfigurationer kan upptäckas direkt när nya resurser skapas eller befintliga resurser ändras. På så sätt behöver organisationen inte vänta till nästa kvartalsrapport för att upptäcka att en intern resurs har blivit exponerad.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Visar att samtliga interna resurser uppfyller kraven på nätverksisolering. Det innebär att organisationens interna system inte är direkt exponerade mot internet och att åtkomst sker genom godkända anslutningsvägar.
- **Dåligt värde (under 100 %):** Innebär att minst en intern resurs saknar korrekt nätverksisolering, har blivit exponerad genom en publik IP-adress eller inte skyddas av nödvändiga nätverkspolicies.
- **Åtgärd:** Om en avvikelse upptäcks ska den berörda resursen undersökas omedelbart. Om en publik IP-adress har tilldelats av misstag ska exponeringen tas bort genom en kontrollerad ändring i Terraform.

  Därefter bör Cloud Audit Logs granskas för att identifiera hur och när förändringen skedde samt vem eller vad som orsakade den. Det är viktigt att förstå grundorsaken så att samma problem inte uppstår igen.

  Slutligen bör organisationen komplettera sina automatiska säkerhetskontroller i Checkov med regler som blockerar framtida försök att skapa publikt exponerade interna resurser. På så sätt blir åtgärden inte bara en lösning på det aktuella problemet, utan även en förbättring av det långsiktiga säkerhetsarbetet.

---

## Samlad ledningsrapportering

Jag har valt dessa tre KPI:er eftersom de tillsammans ger en bredare och mer balanserad bild av organisationens tekniska säkerhetsarbete. De fokuserar på olika delar av säkerheten och kompletterar därför varandra. Tillsammans hjälper de ledningen att förstå både hur bra vi hanterar befintliga säkerhetsproblem och hur väl vi arbetar för att förhindra att nya problem uppstår.

De tre mätetalen fokuserar på följande områden:

1. **Åtgärdstid och sårbarhetshantering (KPI 1):** Visar hur snabbt organisationen reagerar på redan identifierade säkerhetsproblem. Det handlar om att minska tiden som kritiska och höga sårbarheter finns kvar i systemen och därmed begränsa möjligheten för angripare att utnyttja dem.

2. **Förebyggande säkerhetsarbete och automatisering (KPI 2):** Visar hur bra organisationen är på att förhindra säkerhetsproblem redan under utvecklingsprocessen. Genom automatiserade kontroller i CI/CD-flödet kan felaktiga konfigurationer upptäckas innan de når produktionsmiljön. Detta minskar behovet av att åtgärda problem i efterhand.

3. **Nätverksisolering och minskad attackyta (KPI 3):** Visar hur väl organisationen skyddar sina interna resurser från direkt åtkomst via internet. Genom att säkerställa att interna system är isolerade minskar risken för obehörig åtkomst och externa attacker.

### Trender och beslut

När ledningen följer upp dessa KPI:er är det viktigt att inte bara titta på varje enskilt resultat, utan även undersöka hur de påverkar varandra över tid.

Ett exempel är om KPI 2 fortsätter att visa 100 % samtidigt som KPI 1 börjar sjunka under 80 %. Detta kan tyda på att organisationens automatiska säkerhetskontroller fungerar bra och att nya infrastrukturändringar håller en hög säkerhetsnivå. Samtidigt kan det visa att utvecklingsteamet inte hinner åtgärda de sårbarheter som redan finns i systemen.

Detta är en viktig signal för ledningen eftersom det innebär att organisationen är bra på att förebygga nya problem, men har svårigheter att hantera befintliga säkerhetsrisker. Om situationen fortsätter finns det en risk att säkerhetsskulden växer och att fler sårbarheter blir kvar i systemen under längre tid.

Ett möjligt beslut i detta läge är att tillfälligt minska prioriteringen av ny funktionalitet och i stället avsätta mer tid och resurser till säkerhetsuppdateringar och sårbarhetshantering.

Ett annat exempel är om KPI 3 sjunker under 100 %. Det skulle innebära att minst en intern resurs inte längre uppfyller kraven på nätverksisolering. Eftersom en sådan exponering kan innebära en direkt säkerhetsrisk behöver detta prioriteras omedelbart, oavsett hur bra resultaten för de andra KPI:erna ser ut.

Genom att följa utvecklingen över flera månader kan ledningen även identifiera återkommande problem och avgöra om det behövs förändringar i arbetssätt, tekniska skydd eller resursfördelning.

### Vad mätetalen inte visar

Även om dessa tre KPI:er ger en bra bild av organisationens tekniska säkerhetsarbete är det viktigt att förstå att de inte täcker alla delar av cybersäkerheten.

Mätetalen fokuserar framför allt på tekniska faktorer som kända sårbarheter, infrastrukturkonfigurationer och nätverksisolering. De visar däremot inte hur väl organisationen hanterar mänskliga säkerhetsrisker, exempelvis nätfiske, social engineering eller misstag som uppstår på grund av bristande säkerhetsmedvetenhet.

De tar inte heller hänsyn till okända sårbarheter, så kallade nolldagarsbrister, som ännu inte har identifierats eller fått någon tillgänglig säkerhetsuppdatering. Dessutom omfattas inte alla risker som kan uppstå genom externa leverantörer och tredjepartstjänster.

Det finns även en risk att ett bra KPI-resultat ger en alltför positiv bild om man inte undersöker vad som faktiskt ligger bakom siffrorna. Exempelvis innebär 100 % godkända CI-kontroller inte att infrastrukturen är helt säker, utan endast att de konfigurerade kontrollerna inte har upptäckt några allvarliga avvikelser.

Därför bör dessa KPI:er betraktas som ett verktyg för att följa upp organisationens tekniska säkerhetsnivå och identifiera områden som behöver förbättras. För att få en mer heltäckande bild av säkerhetsläget behöver mätetalen kompletteras med andra aktiviteter, exempelvis regelbundna säkerhetsutbildningar, riskanalyser, granskningar av externa leverantörer och återkommande penetrationstester.

På så sätt kan organisationen kombinera tekniska mätvärden med andra säkerhetskontroller och få en bättre förståelse för vilka risker som finns och vilka åtgärder som behöver prioriteras.
