# Individuell rapport

## 1. Introduktion och projektöversikt

**Vad handlade projektet om?**

Vårt Blue Team projekt handlade om att förbättra säkerheten i en server och dess infrastruktur så mycket som möjligt. Arbetet gick ut på att identifiera potentiella säkerhetsrisker, dokumentera dem, undersöka hur de kunde åtgärdas och sedan genomföra förbättringarna. Därefter fortsatte vi med att leta efter nya risker och upprepa processen.

Målet var att steg för steg stärka säkerheten, minska antalet sårbarheter och skapa en mer stabil och säker infrastruktur.

**Mitt perspektiv:**

Mitt arbete fokuserade främst på att arbeta med de säkerhetsrisker som dokumenterades som issues i GitHub. Jag undersökte problemen, arbetade med att åtgärda dem och dokumenterade vilka ändringar jag hade gjort och varför. Utöver detta arbetade jag även med att förbättra olika delar av infrastrukturen, framför allt åtkomstkontroll, nätverkssäkerhet och konfigurationer.

---

## 2. Mitt eget arbete och mina bidrag

**Vad arbetade jag med?**

Jag deltog i arbetet med flera olika issues under projektets gång. Ett exempel är Issue #29, där jag arbetade med att begränsa behörigheterna för Terraform bucketen och minska andra teams åtkomst till våra Terraform state filer.

Jag arbetade även med Tailscales ACL policyer, där jag skapade och justerade ACL regler, policyfiler och tillhörande konfigurationer för att bättre kontrollera vilken åtkomst olika användare och grupper skulle ha.

Utöver detta arbetade jag med att konfigurera versionshantering för Terraform state bucketen och skapa en livscykelregel för att hantera lagringen. Jag deltog även i granskningen av andra gruppmedlemmars Pull Requests genom att läsa igenom ändringarna och godkänna de som var redo att slås ihop.

**Hur genomförde jag arbetet?**

För att kunna lösa uppgifterna behövde jag lägga en hel del tid på att undersöka problemen och lära mig hur de olika delarna av infrastrukturen fungerade. Jag började med att läsa igenom de dokumenterade issues för att förstå vad problemet var, varför det utgjorde en säkerhetsrisk och vilka delar av systemet som behövde ändras.

Därefter använde jag olika kommandon och verktyg för att hitta relevanta filer, inställningar, kodrader och behörigheter som var kopplade till problemen. Jag gick igenom flera delar av projektets filer och konfigurationer för att förstå hur de fungerade tillsammans och vilka ändringar som behövdes.

Innan jag gick vidare med ändringarna testade jag dem i separata branches. På så sätt kunde jag kontrollera att konfigurationerna fungerade som förväntat och att ändringarna inte skapade nya problem eller krävde ytterligare justeringar.

Jag dokumenterade också var problemen fanns, vilka filer jag hade ändrat, vad jag hade ändrat och varför jag hade valt just den lösningen. Detta gjorde det enklare för andra gruppmedlemmar att förstå mitt arbete och granska ändringarna.

**Vad blev resultatet?**

Jag hade inte huvudansvaret för att identifiera alla säkerhetsproblem från början, eftersom andra gruppmedlemmar också arbetade aktivt med att hitta och dokumentera nya issues. Däremot bidrog jag genom att undersöka och åtgärda flera av de problem som identifierades.

Genom att arbeta med ACL policyer, IAM behörigheter och Terraform konfigurationer bidrog jag till att begränsa onödig åtkomst och förbättra säkerheten i infrastrukturen. Jag bidrog även till en tydligare struktur för behörigheter och åtkomst mellan olika grupper.

---

## 3. Resultat och bevis

**Vilka resultat fick jag fram?**

Genom mitt arbete bidrog jag till att förbättra säkerheten i infrastrukturen genom att åtgärda och minska flera identifierade risker. Vissa problem kunde vid första anblick verka mindre betydelsefulla, men visade sig kunna innebära större säkerhetsrisker när man undersökte dem närmare.

Ett exempel var de för breda behörigheterna för Terraform-bucketen och andra gruppers åtkomst till våra state-filer. Detta visade hur till synes små konfigurationsproblem kan skapa risker för obehörig åtkomst och påverka flera team.

Utöver mina egna ändringar deltog jag även i granskningen av flera Pull Requests. Jag läste igenom andras ändringar och godkände relevanta Pull Requests när jag bedömde att de var redo. På så sätt bidrog jag även till att kontrollera kvaliteten på ändringarna innan de integrerades i projektet.

**Vilket underlag har jag?**

Nedan finns några av de GitHub-issues som är kopplade till mitt arbete och mina bidrag under projektet:

- [Issue #13](https://github.com/ITSX25-Chas/itsx25-infra/issues/13)
- [Issue #29](https://github.com/ITSX25-Chas/itsx25-infra/issues/29)
- [Issue #52](https://github.com/ITSX25-Chas/itsx25-infra/issues/52)
- [Issue #70](https://github.com/ITSX25-Chas/itsx25-infra/issues/70)

---

## 4. Slutsatser och rekommendationer

**Vad kom jag fram till?**

Efter att ha undersökt IAM behörigheterna för Terraform bucketen kom jag fram till att behörigheterna var för breda och inte tillräckligt begränsade mellan de olika teamen. Detta innebar en potentiell säkerhetsrisk eftersom andra teams CI konton kunde få åtkomst till information som tillhörde vårt team.

Genom mitt arbete med Tailscales ACL policyer fick jag också en bättre förståelse för hur viktigt det är att ha tydligt dokumenterade regler och kontrollera vilka behörigheter olika användare och grupper faktiskt behöver. Jag insåg även hur lätt mindre fel i en konfiguration kan skapa större säkerhetsproblem.

Om sådana problem inte upptäcks och åtgärdas kan konsekvenserna bli allvarliga om en angripare får åtkomst till ett konto eller en tjänst med för höga behörigheter. Det kan i värsta fall innebära att angriparen får åtkomst till känslig information eller kan påverka flera teams resurser och konfigurationer.

**Vad rekommenderar jag?**

Jag rekommenderar att IAM behörigheterna för Terraform bucketen granskas och begränsas så att varje team endast har tillgång till sina egna state filer och resurser. Onödiga projektbaserade behörigheter bör tas bort och åtkomsten bör kontrolleras regelbundet.

Jag rekommenderar även att användare och tjänstekonton organiseras i tydliga grupper med rätt behörigheter för sina arbetsuppgifter. ACL policyer och andra åtkomstregler bör dokumenteras och uppdateras när infrastrukturen eller behoven förändras.

Genom att följa principen om minsta behörighet och regelbundet kontrollera konfigurationerna kan organisationen minska risken för obehörig åtkomst och begränsa konsekvenserna om ett konto skulle bli komprometterat.

---

## 5. Användning av AI under projektet

**Hur använde jag AI?**

Under projektet använde jag AI som ett hjälpmedel för att lära mig mer och förstå olika tekniska problem. Eftersom en stor del av arbetet bestod av självständiga undersökningar och problemlösning använde jag verktyg som ChatGPT och Claude för att få förklaringar, vägledning och hjälp med dokumentation.

Jag använde AI för att förstå hur olika delar av infrastrukturen fungerade, hur man kunde identifiera säkerhetsproblem och vilka möjliga lösningar som fanns. Jag använde det även för att få hjälp med kod och konfigurationer när jag stötte på problem som jag inte hade tillräcklig kunskap om sedan tidigare.

Jag försökte dock inte bara använda AI för att få färdiga svar, utan även för att förstå varför ett problem uppstod och hur en viss lösning fungerade.

**Konkreta exempel:**

Ett tydligt exempel var när jag arbetade med IAM behörigheterna för Terraform bucketen. Jag använde Claude för att få hjälp med att förstå hur jag kunde hitta och undersöka de befintliga behörigheterna, vilka behörigheter som kunde vara lämpliga att använda i stället och hur jag kunde begränsa åtkomsten.

Jag använde svaren som vägledning, men kontrollerade även om de föreslagna behörigheterna var tillräckliga för att minska åtkomsten utan att hindra oss från att utföra vårt arbete. Det var viktigt att inte bara ta bort behörigheter, utan att säkerställa att systemet fortfarande fungerade som det skulle.

**Hur kontrollerade jag AI:s svar?**

Jag försökte alltid kontrollera informationen som AI gav mig innan jag använde den i projektet. När det handlade om dokumentation läste jag igenom innehållet och korrigerade formuleringar eller påståenden som inte var tillräckligt konkreta eller som inte stämde med projektets faktiska konfiguration.

När jag använde AI för kod och konfigurationer gick jag igenom koden för att förstå vad de olika delarna gjorde och varför de behövdes. Om det fanns något jag var osäker på undersökte jag det vidare genom dokumentation och andra informationskällor.

Vi hade dessutom en granskningsprocess där minst två personer skulle granska Pull Requests. Det innebar att mina ändringar inte bara kontrollerades av mig själv, utan även av andra gruppmedlemmar innan de godkändes.

**När är AI lämpligt och olämpligt att använda?**

Jag tycker att AI är ett användbart hjälpmedel när man behöver förstå hur kod fungerar, få en förklaring av ett fel eller hitta möjliga sätt att lösa ett problem. Det kan även vara ett bra verktyg för att lära sig nya tekniker och få en bättre förståelse för ämnen man inte har arbetat med tidigare.

Däremot är det viktigt att komma ihåg att AI kan ge felaktiga svar eller föreslå lösningar som inte passar den aktuella situationen. Under projektet märkte jag även att AI ibland kunde fastna i en loop där den upprepade samma förslag trots att jag förklarade att lösningen inte fungerade.

Därför anser jag att AI bör användas som ett stöd och inte som en ersättning för egen kunskap, undersökning och kontroll. Inom cybersäkerhet är det särskilt viktigt att själv verifiera information och kod eftersom felaktiga lösningar kan skapa nya säkerhetsproblem.

---

## 6. Personlig reflektion och koppling till framtida yrkesroll

**Vad har jag lärt mig?**

Jag har lärt mig en hel del under projektets gång, framför allt om hur en sådan här infrastruktur fungerar i praktiken, vad man behöver kontrollera ur ett säkerhetsperspektiv och hur olika problem kan identifieras och åtgärdas.

Jag har fått en bättre förståelse för bland annat IAM behörigheter, ACL policyer, nätverkssäkerhet och hur olika konfigurationer påverkar säkerheten i ett system. Jag har även fått mer erfarenhet av att undersöka problem på egen hand, läsa dokumentation, testa lösningar och dokumentera ändringar.

Samtidigt skulle jag säga att mycket av det jag lärde mig var en fördjupning av kunskaper som jag redan hade fått under utbildningen. Skillnaden var att jag nu fick använda dessa kunskaper i ett större projekt där problemen var mer verklighetsbaserade och där ändringarna behövde fungera tillsammans med resten av infrastrukturen.

**Vad skulle jag göra annorlunda nästa gång?**

Om jag skulle göra om projektet skulle jag framför allt försöka arbeta lite snabbare och bli ännu mer effektiv i min problemlösning. Jag skulle även försöka kommunicera mer med mina gruppmedlemmar om deras arbete, till exempel genom att fråga hur de hade undersökt och löst sina problem.

På så sätt hade jag kunnat få en bättre förståelse för fler delar av projektet och lära mig av andras arbetssätt och erfarenheter. Det hade även kunnat ge mig fler möjligheter att bidra till andra delar av infrastrukturen.

**Hur kan jag använda detta i min framtida yrkesroll?**

Kunskaperna och erfarenheterna från projektet kommer att vara användbara i min framtida yrkesroll inom IT och cybersäkerhet. Jag har inte bara fått bättre förståelse för hur man löser specifika problem, utan även utvecklat min förmåga att undersöka, förstå och felsöka problem på egen hand.

Jag tror att detta kommer att göra det lättare för mig att arbeta mer effektivt i framtiden. När jag stöter på liknande problem kommer jag att ha en bättre grund att utgå ifrån och kunna hitta lösningar snabbare, i stället för att behöva börja om från början varje gång.

Framför allt har projektet gett mig en bättre förståelse för hur viktigt det är att tänka på säkerhet även i mindre detaljer. Små misstag i behörigheter eller konfigurationer kan få stora konsekvenser, och det är något jag kommer att ta med mig i mitt framtida arbete.
