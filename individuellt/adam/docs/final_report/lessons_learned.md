# Lessons Learned

## 1. Åtkomstkontroll och principen om minsta behörighet

**Vad hände?**

Vi upptäckte två problem med åtkomstkontrollen som var kopplade till varandra. För det första hade Terraform bucketen bredare behörigheter än vad som behövdes. För det andra hade även andra teams CI konton tillgång till vårt teams Terraform state-filer. Det innebar att andra teams CI konton potentiellt kunde läsa eller ändra filer som tillhörde vårt team, beroende på vilka behörigheter de hade.

**Orsak:**

Bucketen använde projektbaserade IAM behörigheter som gav användare och CI konton större åtkomst än vad de behövde. Behörigheterna var inte tillräckligt begränsade till respektive team och deras resurser.

**Konsekvens:**

Om ett annat teams CI konto eller en annan identitet skulle bli komprometterad skulle en angripare potentiellt kunna använda dess behörigheter för att komma åt våra Terraform state filer. Dessa filer kan innehålla känslig information om vår infrastruktur och hur den är konfigurerad. Beroende på behörigheterna skulle angriparen även kunna ändra filerna, vilket kan leda till ytterligare säkerhetsproblem och problem med infrastrukturen.

Vi testade inte åtkomsten med ett annat teams CI konto. Risken identifierades genom att undersöka de befintliga IAM behörigheterna.

**Lärdom:**

Användare och tjänstekonton ska endast ha de behörigheter som krävs för att utföra sina arbetsuppgifter. Detta kallas principen om minsta behörighet (Least Privilege). Man bör också regelbundet kontrollera behörigheterna för att säkerställa att endast rätt personer och konton har tillgång till rätt resurser.

**Rekommenderad förbättring:**

Granska och begränsa IAM behörigheterna för Terraform bucketen. Varje team ska endast ha åtkomst till sina egna state filer och resurser. Ta bort onödiga projektbaserade behörigheter och kontrollera regelbundet vilka användare och CI konton som har åtkomst.

**Underlag:**
- [Issue #29 – Terraform state bucket permissions](https://github.com/ITSX25-Chas/itsx25-infra/issues/29)

---

## 2. Nätverkssäkerhet och testning

**Vad hände?**

Teamet konfigurerade brandväggsregler och nätverkssegmentering för att kontrollera vilken trafik som skulle tillåtas och blockeras mellan olika delar av infrastrukturen.

**Orsak:**

Vi upptäckte att regler i molnets brandvägg och brandväggsregler på själva servern kan påverka varandra. Det kan göra nätverkskonfigurationen mer komplicerad än förväntat och leda till att trafiken inte fungerar som man tänkt sig.

**Konsekvens:**

Om brandväggsreglerna är felaktigt konfigurerade kan tjänster bli tillgängliga för obehöriga. Det finns också en risk att legitim trafik blockeras, vilket kan göra att tjänster eller funktioner slutar fungera.

**Lärdom:**

Det räcker inte att bara konfigurera brandväggsregler. Man måste även testa att reglerna fungerar som planerat. Det är viktigt att kontrollera både trafik som ska tillåtas och trafik som ska blockeras.

**Rekommenderad förbättring:**

Automatisera nätverkstester för att kontrollera att rätt trafik tillåts och att obehörig trafik blockeras. Tester bör även köras efter ändringar i brandväggsreglerna och efter omstarter av servrar.

**Underlag:**
- [Dokumentation om intern brandvägg](https://github.com/ITSX25-Chas/itsx25-infra/blob/main/docs/internal-firewall.md)
- [Automatiserade nätverkstester](https://github.com/ITSX25-Chas/itsx25-infra/blob/main/tests/network_firewall.py)

---

## 3. Övervakning och säkerhetsskanning

**Vad hände?**

Teamet implementerade automatiserad sårbarhetsskanning för att hitta säkerhetsproblem och ett system för att skicka notiser när något behöver uppmärksammas.

**Orsak:**

En säkerhetsskanner kan själv drabbas av problem eller misslyckas med att genomföra sina kontroller. Om det inte finns tillräcklig övervakning av skanningen kan ett misslyckande inträffa utan att någon får en notis om det.

**Konsekvens:**

Om skanningen slutar fungera utan att någon upptäcker det kan nya sårbarheter förbli oupptäckta. Det finns även en risk att teamet tror att infrastrukturen är säker, trots att säkerhetskontrollerna inte längre fungerar.

**Lärdom:**

Det räcker inte att övervaka infrastrukturen och leta efter säkerhetsproblem. Man måste även övervaka själva säkerhetssystemen för att säkerställa att de fungerar som de ska.

**Rekommenderad förbättring:**

Lägg till separat övervakning som upptäcker om skanningsjobben misslyckas eller slutar köras. Kontrollera även att säkerhetsnotiser faktiskt skickas och når rätt mottagare.

**Underlag:**
- [Dokumentation om säkerhetsskannern](https://github.com/ITSX25-Chas/itsx25-infra/blob/main/docs/security-scanner.md)
- [Issue #132 – Automatiserad säkerhetsskanning](https://github.com/ITSX25-Chas/itsx25-infra/issues/132)

---

## Sammanfattning för ledningen

Under projektet arbetade teamet med att förbättra säkerheten i infrastrukturen genom bland annat åtkomstkontroll, nätverkssäkerhet och automatiserad säkerhetsövervakning. Arbetet visade att det finns flera viktiga områden att tänka på för att minska säkerhetsrisker.

En viktig upptäckt var att IAM-behörigheterna för Terraform-bucketen var för breda. Det innebar att andra teams CI-konton potentiellt kunde komma åt vårt teams Terraform state-filer. Vi såg också hur viktigt det är att testa brandväggsregler för att säkerställa att endast rätt nätverkstrafik tillåts. Dessutom visade arbetet med säkerhetsskanning att det inte räcker att ha automatiserade kontroller. Man måste även kontrollera att skanningen och notiserna fungerar som de ska.

För att förbättra säkerheten rekommenderar vi att behörigheter regelbundet granskas och begränsas enligt principen om minsta behörighet. Vi rekommenderar även att nätverkstester automatiseras och att säkerhetsskanningen får separat övervakning.

Genom att genomföra dessa förbättringar kan organisationen minska risken för obehörig åtkomst, felaktiga nätverksinställningar och oupptäckta säkerhetsproblem.
