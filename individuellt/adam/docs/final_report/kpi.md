## KPI 1

### Namn
Andel kritiska och höga sårbarheter som åtgärdas inom fastställd SLA-tid.

### Syfte och mottagare
- **Mottagare:** CISO, IT-chef och produktägare.
- **Syfte:** Ger ledningen en tydlig bild av hur bra organisationen är på att hantera allvarliga säkerhetsbrister inom rimlig tid. Måttet visar om vi lyckas åtgärda risker innan de hinner utnyttjas eller om vi samlar på oss en växande säkerhetsskuld. För en person utan teknisk bakgrund kan det sammanfattas med frågan: *"Låter vi kända säkerhetsrisker finnas kvar för länge?"*

### Definition och beräkning
Mäter hur stor andel av de kritiska och höga sårbarheterna som har åtgärdats och driftsatts inom den bestämda tidsgränsen. För kritiska sårbarheter gäller högst 7 dagar och för höga sårbarheter högst 14 dagar.

Beräkning: (Antal kritiska och höga sårbarheter som åtgärdats inom SLA / Totalt antal upptäckta kritiska och höga sårbarheter under perioden) × 100

### Datakälla och datakvalitet
- **Datakälla:** GitHub Issues och automatiska säkerhetsskanningar i repot (`itsx25-infra`).
- **Begränsningar:** Resultatet är beroende av att alla upptäckta sårbarheter registreras korrekt. Måttet tar inte hänsyn till hur komplicerad en åtgärd är. Det skiljer exempelvis inte mellan en enkel uppdatering av en programversion och en större förändring i systemarkitekturen. Det tar inte heller hänsyn till tillfälliga skyddsåtgärder, exempelvis regler i en WAF.

### Målvärde eller önskad riktning
- **Målvärde:** Minst 95 % för kritiska sårbarheter och minst 90 % för höga sårbarheter.
- **Akutgräns:** Kritiska sårbarheter med en känd exploit eller möjlighet till direkt kodkörning (RCE) ska hanteras inom 48 timmar.

### Mätfrekvens
Resultatet sammanställs varje månad och rapporteras till ledningen. Teamet följer även upp utvecklingen varje vecka.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (över 90–95 %):** Det visar att teamet har bra kontroll över säkerhetsarbetet och kan åtgärda allvarliga brister innan de hinner orsaka problem.
- **Dåligt värde (under 80 %):** Kan tyda på att teamet har för hög arbetsbelastning eller att nya funktioner prioriteras framför nödvändiga säkerhetsuppdateringar.
- **Åtgärd:** Om resultatet hamnar under målet bör ledningen och produktägaren prioritera om arbetet. Det kan innebära att utvecklingen av nya funktioner pausas under nästa sprint för att resurser i stället ska läggas på att åtgärda befintliga säkerhetsbrister.

---

## KPI 2

### Namn
Andel infrastrukturändringar som godkänns av CI-kontroller utan säkerhetsbrister (IaC Compliance).

### Syfte och mottagare
- **Mottagare:** IT-chef och utvecklingsansvarig.
- **Syfte:** Visar hur bra vi är på att upptäcka och förhindra osäkra inställningar innan de når molnmiljön. Det kan exempelvis handla om öppna brandväggar, publika lagringsytor eller behörigheter som ger användare mer åtkomst än nödvändigt. Målet är att upptäcka och stoppa problemen redan under utvecklingen i stället för att behöva åtgärda dem efteråt.

### Definition och beräkning
Mäter andelen pull requests i infrastrukturrepot (`itsx25-infra`) som klarar de automatiska säkerhetskontrollerna Checkov och TFLint i GitHub Actions utan allvarliga regelbrott innan de mergas till `main`.

Beräkning: (Antal mergade pull requests utan säkerhetsavvikelser / Totalt antal mergade pull requests i itsx25-infra) × 100

### Datakälla och datakvalitet
- **Datakälla:** Loggar från bygg- och kontrollprocessen `pr-checks.yml` i GitHub Actions.
- **Begränsningar:** Eftersom kontrollerna utförs automatiskt är resultatet relativt objektivt och tillförlitligt. En begränsning är dock att Checkov endast kan upptäcka säkerhetsproblem som omfattas av dess befintliga regler. Det innebär att mer avancerade designfel eller problem som saknar specifika kontrollregler kan passera utan att upptäckas.

### Målvärde eller önskad riktning
- **Målvärde:** 100 %. Alla infrastrukturändringar som innehåller säkerhetsavvikelser ska stoppas innan de når `main`.

### Mätfrekvens
Mätningen sammanställs varje månad och omfattar samtliga pull requests som har mergats under perioden.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Visar att våra automatiska säkerhetskontroller fungerar som de ska och förhindrar att osäkra konfigurationer når produktionsmiljön.
- **Dåligt värde (under 100 %):** Kan innebära att någon har kringgått säkerhetskontrollerna, exempelvis genom att forcera en merge eller använda otillåtna undantag.
- **Åtgärd:** Den berörda pull requesten ska undersökas direkt. Om ändringen innebär en säkerhetsrisk bör den återställas. Därefter behöver inställningarna för branch protection och administratörsbehörigheter i GitHub kontrolleras.

---

## KPI 3

### Namn
Andel interna resurser som har kontrollerad och verifierad nätverksisolering (Attack Surface Index).

### Syfte och mottagare
- **Mottagare:** CISO och IT-infrastrukturansvarig.
- **Syfte:** Ger ledningen en uppfattning om hur väl organisationens interna system är skyddade från åtkomst via det publika internet. Måttet visar om interna servrar och tjänster är korrekt isolerade och inte kan nås direkt utifrån. Det hjälper oss att säkerställa att interna resurser inte exponeras genom publika IP-adresser i onödan.

### Definition och beräkning
Mäter andelen interna servrar, containrar och tjänster som uppfyller kraven för nätverksisolering. Det innebär att resurserna inte ska ha någon publik IP-adress, att åtkomst endast ska ske via Google IAP eller vårt Headscale-tailnät och att Kubernetes-poddar ska skyddas av aktiva NetworkPolicies.

Beräkning: (Antal interna arbetslaster med verifierad nätverksisolering / Totalt antal driftsatta interna arbetslaster) × 100

### Datakälla och datakvalitet
- **Datakälla:** Terraform State, GCP Console API och information om aktiva nätverkspolicies i Kubernetes-klustret.

### Målvärde eller önskad riktning
- **Målvärde:** 100 %.
- **Gränsvärde:** Om en intern server eller databas av misstag får en publik IP-adress ska detta betraktas som en allvarlig säkerhetsavvikelse som behöver hanteras omedelbart.

### Mätfrekvens
Resultatet rapporteras till ledningen varje kvartal. Utöver detta genomförs automatiska kontroller vid varje ny driftsättning.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Visar att interna resurser är korrekt skyddade och att obehöriga från internet inte kan ansluta till eller skanna dessa system.
- **Dåligt värde (under 100 %):** Innebär att minst en intern resurs har blivit exponerad mot internet eller saknar en korrekt nätverkspolicy.
- **Åtgärd:** Den publika IP-adressen ska tas bort omedelbart genom Terraform. Därefter behöver Cloud Audit Logs granskas för att ta reda på hur exponeringen uppstod. Slutligen bör Checkov uppdateras med ytterligare kontroller för att förhindra att samma typ av problem uppstår igen.

---

## Samlad ledningsrapportering

Jag har valt dessa tre KPI:er eftersom de tillsammans ger en bra överblick över organisationens säkerhetsarbete. De fokuserar på tre viktiga områden som kompletterar varandra:

1. **Åtgärdstid (KPI 1):** Visar hur snabbt vi upptäcker och åtgärdar redan identifierade säkerhetsbrister.
2. **Förebyggande säkerhetsarbete (KPI 2):** Visar hur effektiva våra automatiska kontroller är på att stoppa osäkra ändringar innan de når molnmiljön.
3. **Nätverkssäkerhet (KPI 3):** Visar hur väl våra interna system är isolerade från internet och hur liten vår externa attackyta är.

**Trender och beslut:**

En viktig sak att hålla koll på är om KPI 2 fortsätter att ligga på 100 % samtidigt som KPI 1 sjunker under 80 %. Det kan vara ett tecken på att våra automatiska kontroller fungerar bra och att nya ändringar håller en hög säkerhetsnivå, men att teamet inte hinner med att åtgärda redan upptäckta sårbarheter.

I ett sådant läge får ledningen ett tydligt underlag för att fatta beslut om prioriteringar. Ett exempel är att tillfälligt minska arbetet med nya funktioner och i stället lägga mer tid på att åtgärda befintliga säkerhetsproblem.

**Vad mätetalen inte visar:**

Det är viktigt att förstå att dessa KPI:er främst mäter tekniska säkerhetsaspekter, exempelvis konfigurationer, nätverksinställningar och kända sårbarheter i kod och infrastruktur. De ger däremot ingen fullständig bild av organisationens totala säkerhetsnivå.

Faktorer som mänskliga misstag, nätfiske, social engineering, okända nolldagarsattacker och säkerhetsrisker hos externa leverantörer omfattas inte av dessa mätningar.

Därför bör KPI:erna ses som ett verktyg för att följa upp den tekniska säkerheten, snarare än ett komplett mått på organisationens cybersäkerhet. För att få en mer heltäckande bild behöver de även kompletteras med regelbundna säkerhetsutbildningar, riskbedömningar och externa penetrationstester.
