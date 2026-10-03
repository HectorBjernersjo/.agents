Som sista review-steg, markera findings med lågt värde som `ignored-by-ai` istället för att lämna dem som pending.
Behåll bortfiltrerade findings i `review-data.js` med en tydlig `ignoreReason`.
För varje finding som nyligen markerats `ignored-by-ai`, lägg till en `ignored`-rad med `"ignoredBy":"ai"` i `<review-root>/_review-index/ignored-findings.jsonl`, om inte samma `pr`, `findingId`, `fingerprint` och `event` redan finns.

Markera ett finding som `ignored-by-ai` när det:

- Tar upp något som redan täcks av review-kontexten.
- Redan har ignorerats i en tidigare review. Slå upp findingens `files` i `<review-root>/_review-index/ignored-findings.jsonl`. Indexet är append-only, så använd senaste eventet för samma `pr`, `findingId` och `fingerprint` för att se om ignoreringen fortfarande gäller. Räkna det bara som samma finding när det tydligt handlar om samma sak: överlappande `files`, samma eller liknande agent eller kategori, och matchande `fingerprint` eller i stort sett samma `title`/`problem`. Skriv i `ignoreReason` vilken tidigare ignorering det gäller.
- Föreslår en onödig refactor som skulle göra koden sämre.
- Påstår att något är en bugg när det faktiskt inte är det.
- Flaggar beteende som uppenbart är avsiktligt.
- Pekar på kod som fanns sedan tidigare och inte ändrats i den här PR:en, om det inte är väldigt viktigt att det fixas ändå.
- Är en dubblett av ett annat finding. Slå ihop dubbletter till det bästa enskilda findingen där det är vettigt.
- Pekar på UTF-8 BOM; tester täcker det och det behöver ingen PR-kommentar.
- Säger att något är dåligt när det faktiskt är bra.
- Föreslår att göra en klass sealed.
- Kommenterar commit-meddelanden; PR:er squashas ändå.
- Påstår en null reference-risk när det inte finns någon verklig risk.

Markera inte något som `ignored-by-ai` bara för att det är en nitpick eller bara lite användbart.

Bedöm varje finding utifrån den kodändring som blir resultatet, inte utifrån om förslaget har någon teoretisk fördel.

Markera ett finding som `ignored-by-ai` när den föreslagna fixen inte gör kodbasen bättre som helhet. Väg in läsbarhet, enkelhet, underhållbarhet, skörhet, duplicering och faktiskt förebyggande av defekter tillsammans. En lokal fördel räcker inte när den resulterande koden kostar lika mycket eller mer.

Innan du behåller ett finding, tillämpa den föreslagna fixen i huvudet och jämför före och efter. Behåll det bara när den resulterande koden är tydligt bättre.

Om ett påstående går att verifiera genom att söka i docs eller skriva och köra ett litet test, verifiera det innan du bestämmer dig.

När kod ser inkonsekvent ut jämfört med delade eller standardmönster, ta reda på varför innan du föreslår en ändring.

För förslag om refactoring, omdöpning eller extrahering, tänk igenom resultatet: skulle koden faktiskt bli bättre, och är den extra abstraktionen värd det?

Gå igenom varje finding ett i taget. Verifiera koden noggrant för varje finding som behöver verifieras.

Det är okej att det tar tid att gå igenom alla påståenden.
