---
name: user-story
description: Creates a user story from the current pr
disable-model-invocation: true
---

Användaren vill ha hjälp med att skapa en user story från deras pr, användaren kommer att säga vilket pr de vill ha hjälp med.

- Kör exakt "git --no-pager diff master..." för att se vad den här pr:en har gjort.

User storyn ska innehålla följande
- Namn
- Description
- Acceptance criteria
- Release note
- Riskanalys
- PR description

Här kommer lite instruktioner för hur du ska skriva dem:

## User story Description
Ska vara på svenska och ska helst vara skriven som en faktiskt user story. Den ska inte vara skriven som att vi redan har byggt det.
Ta inte med några implementationsdetaljer i den här. den ska vara på en hög nivå så att en pm förstår.
Skriv inte "Som xxx", skriv bara "Vi vill"

## Acceptance criteria
Ska vara i listform, också på ganska hög "oteknisk nivå" (beroende lite på vad det är och om det går) men skriv inte nånting om själva koden här om det inte är nödvändigt.
Du behöver inte göra en massa punkter som säger samma sak, bättre med färre, tydliga punkter.

## Release Note
Skriv en release note för det här pr:et, den ska vara på engelska och ha en header (bara några ord) och en text (max en till några meningar)
Fokusera bara på vad som ändras för användaren, ingenting tekniskt.

## Riskanalys

Info om riskanalys:
---
Riskanalys hjälper oss att proaktivt identifiera och mitigera hot/buggar i våra applikationer så vi kan ha hög kvalitét på våra tjänster. 

Riskanalys bör ske under flera faser av utvecklingsprocessen, den bör även ses över löpande vid eventuella ändringar som påverkar.

Planering: Innan vi startar utveckling bör vi ha viss förståelse för potentiella risker och hur de kan påverka.


Design / Utveckling: När vi utvecklar funktioner så bör vi löpande se över riskanalysen för att beakta och minska eventuella risker.


Release: Innan vi släpper en ny funktion så kan vi tack vare riskanalysen vara förbereda på potentiella utfall och ha en plan för rollback/roll forward.

Exempel: Ny funktion för att se lönespecifikationer i ett företag.
Impact (påverkan): En obehörig person får tillgång till lönedata.
Likelihood (sannolikhet): Sannolikheten att det ska hända.

Om vi hamnar på high/critical risknivå bör vi utreda riskmitigering genom förebyggande åtgärder, beredskapsplaner ifall det inträffar och eventuellt resursallokering för att snabbt utföra beredskapsplanen.

Vid high/critical risk kan det också vara intressant att kommunicera till andra avdelningar, till exempel support och konsulter så att dom snabbt kan svara ifall kunder börjar höra av sig. I vissa fall kan det även vara intressant att kommunicera till kunder redan innan eller åtminstone ha ett servicemeddelande redo att skicka ifall något inträffar. 

Risk impacts:
1 - Negligible
Very minor consequences that would not disrupt normal operations
2 - Minor
Could result in a small disruption, but easy to manage and recover from
3 - Moderate
Would cause a noticeable disruption or harm, might require extra resources to manage and recover
4 -Major
Could result in significant disruption, harm, or financial loss. Recovery might be time-consuming/challenging
5 - Catastrophic
Would cause extreme disruption, long-term harm, or major financial loss. Recovery might be prolonged, complex, or even unattainable

Risk likelihood
1 - Rare
Not expected to occur
2 - Unlikely
Not expected, but possible in exceptional circumstances
3 - Possible
Could occur at some point
4 - Likely
There's a strong possibility that the event will occur in the near future
5 - Almost certain
Likely to occur soon and often

Total risk = risk impact * risk likelihood
Total risk 1 - 3 = low, 4 - 9 = medium, 10 - 12 = high, 15 - 25 = critical

---

Skriv en riskanalys för den här pr:en, den ska ha siffrorna:
- Risk impact (1 - 5, 5 är högt)
- Risk likelihood (1 - 5, 5 är högt)
- Risk (3 - 0, 3 är low, 2 är medium, 1 är high, 0 är critical)

Sen så ska vi ha en text på några meningar som försvarar det vi har valt.
Skriv inte om specifika kodändringar.

Här är några exempel:

---

Low
Ingen större risk, vi samman kopplar ett vy element som ska användas som filter till en grid med 2-10 arbeten. Detta filter element kommer då att filtrera listan. Påverkar ingen existerande data eller
funktion som används av kund.
Om något går fel nu så märkts det snabbt och tydligt, vi är i beta steget så vi hare gott om tid att se över eventuella problem

---

Medium
Vi ändrar valideringen när vi sparar Visma Connect epost på en användare. Den ska nu strunta i allfoner.
Risken är att något med queryn går sönder, och folk inte längre då kan spara eller skapa en användare i vissa case.

Test täcker basfallen och testning sker under utveckling. Om något fel slinker igenom så är det edge cases.

---

Low
Vi skapar en ny komponent vars syfte är att fungera som en knapp eller en presentation av data. Innebär inga risker för drift, data eller förstörelse av andra delar av systemet.

Möjligtvis att komponenten kan ta sönder vyn de läggs till i.
Möjligtvis att stylingen för den påverkar masterstyle filen som då tar sönder hela hrm:s styling. Men e2e testerna fångar detta, och även unittest som kollar så att rätta variabler används i
ds-theme.less.

---

Low

Ren refaktorering och städning av chatbot-koden. Ingen ny funktionalitet, ingen databasändring, inget ändrat beteende. Duplicerad kod konsolideras och kodstil moderniseras.

Det viktigaste: att man kan skicka en fråga, att den söker i dokumentationen och ger ett svar, fungerar som innan. Jag har testat att det fungerar innan PR:en skickades upp. Om något ändå skulle gå fel
påverkas bara chatboten, ingen annan del av systemet.

---


Chatboten är ute i prod så skriv inget om någon feature flag för den.
Du behöver inte förklara vad som har byggts i riskanalysen, bara vilka risker som finns och vad vi har gjort för att förhindra dom.
Om det är något vi inte har gjort nog för, säg till.


## PR
Be användaren skapa en user story och ge dig "siffran" för user storyn.
När hen har gjort det så kan du skapa upp ett pr åt hen med gh cli:t, gör den som en draft och ge användaren en länk.

## PR description
Fokusera på varför jag har gjort det som det är, inte så mycket på exakt vad som har ändrats.
Om det är något lite större eller där det annars är aktuellt kan du även beskriva flödet som man behöver förså i pr:et.
Håll den ganska kortfattad, du behöver inte ta med varenda ändring.
Pr descriptionen ska vara på svenska, den kan ofta vara rätt lik user story descriptionen, men kanske med lite mer tekniska detaljer där det är relevant.
Avsluta pr descriptionen med AB#{numret på user storyn som användaren gav dig}
