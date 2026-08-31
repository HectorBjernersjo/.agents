---
name: frontend-design
description: Vägledning för distinkt, avsiktlig visuell design när du bygger nytt UI eller formar om ett befintligt. Hjälper med estetisk riktning, typografi och val som inte ser ut som mallade standardlösningar.
license: Complete terms in LICENSE.txt
---

# Frontend-design

Ta dig an det här som designchefen på en liten studio känd för att ge varje kund en visuell identitet som inte kan förväxlas med någon annans. Den här kunden har redan förkastat förslag som kändes mallade, och betalar för en distinkt hållning: gör medvetna, uttalade val kring palett, typografi och layout som är specifika för just den här briefen, och ta en riktig estetisk risk du kan motivera.

## Förankra det i ämnet

Om briefen inte slår fast vad produkten eller ämnet är, slå fast det själv innan du designar: namnge ett konkret ämne, dess målgrupp och sidans enda jobb, och säg vad du valt. Om det finns något i ditt minne om människans preferenser, kontext kring vad de bygger, eller designer du gjort tidigare, använd det som en ledtråd. Ämnets egen värld, dess material, instrument, artefakter och jargong, är där distinkta val kommer ifrån. Bygg med briefens riktiga innehåll och ämne rakt igenom.

## Designprinciper

För webbdesign är heron en tes. Öppna med det mest karaktäristiska i ämnets värld, i vilken form som passar det: en rubrik, en bild, en animation, en live-demo, ett interaktivt ögonblick. Var medveten i ditt val: en stor siffra med en liten etikett, stödjande statistik och en gradientaccent är mallsvaret. Använd det bara om det verkligen är det bästa alternativet.

Typografin bär sidans personlighet. Para ihop display- och brödtextsnitten medvetet, inte samma familjer du skulle ta till på vilket annat projekt som helst, och sätt en tydlig typskala med avsiktliga vikter, bredder och avstånd. Gör själva typbehandlingen till en minnesvärd del av designen, inte ett neutralt fordon för innehållet.

Struktur är information. Strukturella grepp, numrering, eyebrows, avdelare, etiketter, ska koda något sant om innehållet, inte dekorera det. Många generiska designer använder numrerade markörer (01 / 02 / 03), men det är bara lämpligt om innehållet faktiskt är en sekvens, som en riktig process eller en tidslinje där ordningen bär information läsaren behöver. Ifrågasätt om val som numrerade markörer faktiskt är vettiga innan du tar in dem.

Använd rörelse medvetet. Fundera på var och om animation kan tjäna ämnet: en sekvens vid sidladdning, en scroll-triggad avslöjning, mikrointeraktioner vid hover, ambient atmosfär. Ett orkestrerat ögonblick landar oftast hårdare än utspridda effekter; välj det riktningen kräver. Men ibland är mindre mer, och extra animation bidrar till känslan av att designen är AI-genererad.

Matcha komplexiteten mot visionen. Maximalistiska riktningar kräver utstuderat utförande; minimala riktningar kräver precision i avstånd, typ och detalj. Elegans är att utföra den valda visionen väl.

Tänk noga på det skrivna innehållet. Ofta innehåller en designbrief inget riktigt innehåll, och det är upp till dig att komma på copy. Copy kan få en design att kännas lika mallad som designen själv. Se sektionen om skrivande nedan för mer vägledning.

## Process: brainstorma, utforska, planera, kritisera, bygg, kritisera igen

För kalibrering: AI-genererad design just nu klumpar ihop sig kring tre looks: (1) en varm cremefärgad bakgrund (nära #F4F1EA) med en högkontrast-serif som display och en terrakotta-accent; (2) en nästan svart bakgrund med en enda skarp syragrön eller vermilion-accent; (3) en broadsheet-liknande layout med hårfina linjer, noll border-radius och täta tidningsliknande kolumner. Alla tre är legitima för vissa briefer, men de är standardval snarare än val, och de dyker upp oavsett ämne. Där briefen slår fast en visuell riktning, följ den exakt. Briefens egna ord vinner alltid, även när den ber om en av de här lookarna. Där den lämnar en axel fri, spendera inte den friheten på en av de här standardvalen. Precis som för en mänsklig designer som anlitas finns det ofta en fin balans mellan att göra det man är bra på och att ta varje projekt som en chans att experimentera och lära sig.

Jobba i två pass. Först, brainstorma en kort designplan utifrån människans designbrief: skapa ett kompakt tokensystem med färg, typ, layout och signatur. Färg: beskriv paletten som 4 till 6 namngivna hexvärden. Typ: typsnitten för 2+ roller (ett karaktärsfullt displaysnitt som används med återhållsamhet, ett kompletterande brödtextsnitt, och ett bruks-snitt för bildtexter eller data om det behövs). Layout: ett layoutkoncept, med enmeningsbeskrivningar i prosa och ASCII-wireframes för att idéa och jämföra. Signatur: det enda unika elementet den här sidan kommer bli ihågkommen för, som förkroppsligar briefen på ett passande sätt.

Granska sedan planen mot briefen innan du bygger: om någon del av den läses som det generiska standardval du skulle producera för vilken liknande sida som helst (kör igenom en liknande prompt för att se om du hamnar på ett liknande ställe) snarare än ett val gjort för just den här briefen, revidera den delen och säg vad du ändrade och varför. Först när du bekräftat att din designplan är relativt unik ska du börja skriva koden, följa den reviderade planen exakt och härleda varje färg- och typbeslut från den.

När du skriver koden, var noga med hur du strukturerar specificiteten i dina CSS-selektorer. Det är lätt att generera CSS-klasser som tar ut varandra (särskilt med en typbaserad selektor som .section och en elementbaserad selektor som .cta). Det händer ofta med paddings/margins mellan sektioner.

Försök göra mycket av den här planeringen och iterationen i ditt tänkande, och visa bara idéer för användaren när du har högre tillförsikt att de kommer att gilla dem.

## Återhållsamhet och självkritik

Spendera din djärvhet på ett ställe. Låt signaturelementet vara den enda minnesvärda grejen, håll allt runt omkring tyst och disciplinerat, och stryk all dekoration som inte tjänar briefen. Att inte ta en risk kan vara en risk i sig! Bygg till ett kvalitetsgolv utan att annonsera det: responsivt ner till mobil, synligt tangentbordsfokus, reduced motion respekterat. Kritisera ditt eget arbete medan du bygger, ta skärmdumpar om din miljö stödjer det. En bild säger mer än 1000 tokens. Tänk på Chanels råd: innan du lämnar huset, titta i spegeln och ta bort en accessoar. Mänskliga skapare har minne och försöker alltid göra något nytt, så om du har en plats att snabbt anteckna vad du provat kan det hjälpa dig i framtida pass.

## Mer om skrivande i design

Ord finns i en design av ett skäl: för att göra den lättare att förstå, och därmed lättare att använda. De är designmaterial, inte dekoration. Ta med samma avsiktlighet till copy som du skulle ta med till avstånd och färg. Innan du skriver något, fråga vad designen behöver säga, och hur det bäst kan sägas för att hjälpa personen navigera upplevelsen.

Skriv från slutanvändarens sida av skärmen. Namnge saker efter vad folk kontrollerar och känner igen, aldrig efter hur systemet är byggt. En person hanterar notiser, inte webhook config. Beskriv vad något gör med enkla ord istället för att sälja det. Att vara specifik är alltid bättre än att vara fyndig.

Använd aktiv form som standard. En kontroll ska säga exakt vad som händer när den används: "Spara ändringar", inte "Skicka". En handling behåller samma namn genom hela flödet, så knappen som säger "Publicera" ger en toast som säger "Publicerad". Ett interfaces vokabulär är skyltningen för någon som navigerar produkten. Sammanhållning och konsekvens är hur folk lär sig hitta.

Behandla fel och tomhet som tillfällen för vägledning, inte stämning. Förklara vad som gick fel och hur det fixas, i interfacets röst snarare än en persons. Fel ber inte om ursäkt, och de är aldrig vaga om vad som hänt. En tom skärm är en inbjudan att agera.

Håll registret samtalsnära och avstämt: enkla verb, sentence case, inget fyllnadsmaterial, med ton matchad till varumärket och målgruppen. Låt varje element göra exakt ett jobb. En etikett etiketterar, ett exempel demonstrerar, och inget gör i smyg dubbelt jobb.
