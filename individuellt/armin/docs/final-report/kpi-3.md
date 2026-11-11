# KPI:er och säkerhetsmätningar

## Syfte och kursmål

I den här delen ska du ta fram tre KPI:er som kan användas för att följa upp säkerhetsläget eller effekten av säkerhetsarbetet.

Arbetet knyter an till:

- **Kursmål 4:** beskriva hur säkerhetsmätningar, KPI:er och compliance-rapportering används för att kommunicera säkerhetsstatus till ledningsnivå.
- **Kursmål 10:** producera säkerhetsmätningar och KPI-rapportering anpassad för en icke-teknisk beslutsfattare.

Utgå från projektets befintliga resultat. Du behöver inte skapa nya tekniska tester enbart för denna del.

En användbar KPI ska hjälpa organisationen att förstå:

- vad som mäts,
- varför det är viktigt,
- hur utvecklingen följs över tid,
- när resultatet kräver beslut eller åtgärd.

Undvik KPI:er som enbart mäter aktivitet, exempelvis "antal genomförda tester". Försök i stället mäta säkerhetsläge, risk, kvalitet, följsamhet eller effekt.

---

## KPI 1

### Namn
Åtgärdsgrad för kritiska och höga sårbarheter inom SLA.

### Syfte och mottagare
- **Mottagare:** CISO, IT-chef och produktägare.
- **Syfte:** Hjälper ledningen att förstå om vi hinner fixa farliga säkerhetsbrister i rimlig tid eller om vi bygger upp en farlig teknisk skuld. För en icke-teknisk beslutsfattare svarar detta helt enkelt på: *"Låter vi kända säkerhetsdörrar stå öppna för länge?"*

### Definition och beräkning
Andelen sårbarheter klassade som *Kritisk* eller *Hög* som vi åtgärdat och produktionssatt inom fastställt SLA (max 7 dagar för kritiska och max 14 dagar för höga brister).

Beräkning: (Antal fixade kritiska och höga sårbarheter inom tidsramen / Totalt antal upptäckta kritiska och höga sårbarheter under perioden) × 100

### Datakälla och datakvalitet
- **Datakälla:** Våra GitHub Issues och larm från automatiska sårbarhetsscanningar i repot (`itsx25-infra`).
- **Begränsningar:** Kvaliteten styrs av att sårbarheter faktiskt registreras som ärenden. Måttet tar inte heller hänsyn till om en brist kräver en stor arkitekturändring kontra en enkel versionsbump, eller om vi infört tillfälliga kompensatoriska skydd (som en WAF-regel) under tiden.

### Målvärde eller önskad riktning
- **Målvärde:** Minst 95 % för kritiska och minst 90 % för höga sårbarheter.
- **Akutgräns:** Kritiska sårbarheter med känd exploit eller direkt kodkörning (RCE) ska hanteras inom 48 timmar.

### Mätfrekvens
Månadsvis sammanställning till ledningen, med veckovis avstämning i teamet.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (över 90–95 %):** Teamet har god kontroll och stänger risker snabbt innan de hinner utnyttjas.
- **Dåligt värde (under 80 %):** Teamet mäktar inte med eller tvingas prioritera nya features framför säkerhet.
- **Åtgärd:** Ligger värdet under målet måste ledningen och produktägaren pausa utveckling av ny funktionalitet i nästa sprint och vika resurser till att stänga säkerhetsskulden.

---

## KPI 2

### Namn
Andel godkända infrastrukturändringar utan säkerhetsavvikelser i CI (IaC Compliance).

### Syfte och mottagare
- **Mottagare:** IT-chef och utvecklingsansvarig.
- **Syfte:** Visar hur effektiva vi är på att stoppa felkonfigurationer (öppna brandväggar, publika lagringshinkar eller breda IAM-roller) innan koden rullas ut i molnmiljön. Det handlar om att förebygga incidenter i stället för att städa i efterhand.

### Definition och beräkning
Andelen pull requests i infrastrukturrepot (`itsx25-infra`) som passerar våra automatiska säkerhetskontroller (Checkov och TFLint) i GitHub Actions utan allvarliga regelbrott när de slås ihop med `main`.

Beräkning: (Antal mergade pull requests med 0 säkerhetsavvikelser / Totalt antal mergade pull requests i itsx25-infra) × 100

### Datakälla och datakvalitet
- **Datakälla:** Bygg- och kontrolloggar från arbetsflödet `pr-checks.yml` i GitHub Actions.
- **Begränsningar:** Datakvaliteten är objektiv och hög eftersom kontrollerna körs maskinellt. Svagheten är att Checkov enbart fångar kända mönster med befintliga regler; logiska designfel utan specifika lintreregler kan slinka igenom.

### Målvärde eller önskad riktning
- **Målvärde:** 100 %. Inga infrastrukturändringar med säkerhetsavvikelser ska tillåtas i `main`.

### Mätfrekvens
Månadsvis uppföljning över alla mergade pull requests.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Våra skyddsspärrar fungerar och hindrar osäkra konfigurationer från att nå molndrift.
- **Dåligt värde (under 100 %):** Någon har kringgått branch protection, forcerat en merge eller infört otillåtna undantag.
- **Åtgärd:** Identifiera berörd PR direkt, rulla tillbaka ändringen och se över inställningarna för branch protection och administratörsbehörigheter i GitHub.

---

## KPI 3

### Namn
Andel interna resurser med verifierad nätverksisolering (Attack Surface Index).

### Syfte och mottagare
- **Mottagare:** CISO och IT-infrastrukturansvarig.
- **Syfte:** Besvarar ledningens raka fråga: *"Hur mycket av våra interna system är helt dolda och oåtkomliga från publika internet?"* Det säkerställer att vi konsekvent upprätthåller nolltolerans mot publika IP-adresser på interna servrar.

### Definition och beräkning
Andelen interna servrar, containrar och tjänster som uppfyller kraven för fullständig nätverksisolering: ingen publik IP-adress tilldelad, access sker uteslutande via Google IAP eller vårt Headscale-tailnät, samt att Kubernetes-poddar skyddas av aktiva NetworkPolicies.

Beräkning: (Antal interna arbetslaster med verifierad isolering / Totalt antal driftsatta interna arbetslaster) × 100

### Datakälla och datakvalitet
- **Datakälla:** Terraform State, GCP Console API samt status för nätverkspolicies i Kubernetes-klustret.

### Målvärde eller önskad riktning
- **Målvärde:** 100 %.
- **Gränsvärde:** Att en intern server eller databas tilldelas publik IP av misstag ska klassas som en omedelbar säkerhetsavvikelse.

### Mätfrekvens
Kvartalsvis ledningsrapport samt automatisk kontroll vid varje ny driftsättning.

### Tolkning och åtgärd vid avvikelse
- **Bra värde (100 %):** Angripare på internet kan inte ansluta till eller scanna interna resurser.
- **Dåligt värde (under 100 %):** En intern resurs har exponerats externt eller saknar nätverkspolicy.
- **Åtgärd:** Koppla omedelbart bort den externa IP-adressen via Terraform, granska Cloud Audit Logs för att utreda orsaken och komplettera Checkov med en spärr som blockerar framtida exponering.

---

## Samlad ledningsrapportering

Jag valde de här tre mätetalen för att de tillsammans ger en balanserad och lättbegriplig bild av organisationens säkerhetsläge. De mäter tre fundamentala delar i säkerhetsarbetet:
1. **Snabbhet (KPI 1):** Hur snabbt vi stänger sårbarheter som redan upptäckts.
2. **Kvalitet och automation (KPI 2):** Hur bra vi är på att hindra misstag från att ens nå molnet via våra CI-kontroller.
3. **Strukturellt grundskydd (KPI 3):** Hur väl vi isolerar våra system så att attackytan mot internet hålls minimal.

**Trender och beslut:**
En trend att vara uppmärksam på är om KPI 2 visar 100 % men KPI 1 börjar sjunka under 80 %. Det är ett tydligt varningstecken på att utvecklarna bygger rätt i grunden, men att arbetsbelastningen är för hög för att hinna med löpande patchning. Detta ger ledningen ett konkret beslutsunderlag: pausa nyutveckling i kommande sprint och avsätt tid för att beta av säkerhetsskulden.

**Vad mätetalen inte visar:**
Siffrorna speglar enbart teknisk konfiguration och kända sårbarheter i vår kod och infrastruktur. De mäter inte mänskliga faktorer (som nätfiske och social engineering), okända nolldagarsbrister eller risker hos externa tredjepartsleverantörer. Mätetalen ska därför betraktas som en teknisk hälsokontroll som alltid måste kompletteras med återkommande utbildningsinsatser och externa penetrationstester.

---

## Kontroll före commit

- [x] Jag har definierat tre relevanta KPI:er.
- [x] KPI:erna mäter mer än enbart genomförda aktiviteter.
- [x] Varje KPI har definition, datakälla och mottagare.
- [x] Varje KPI har ett målvärde, gränsvärde eller en önskad riktning.
- [x] Jag har beskrivit hur KPI:erna ska tolkas och följas upp.
- [x] Jag har beskrivit vad en avvikelse bör leda till.
- [x] Min rapportering är begriplig för en icke-teknisk beslutsfattare.
- [x] Jag har beskrivit KPI:ernas begränsningar.
