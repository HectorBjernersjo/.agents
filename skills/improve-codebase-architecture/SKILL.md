---
name: improve-codebase-architecture
description: Skanna en kodbas efter möjligheter att fördjupa moduler, presentera dem som en visuell HTML-rapport, och grilla sedan igenom den du väljer.
disable-model-invocation: true
---

# Förbättra kodbasens arkitektur

Lyft fram arkitektonisk friktion och föreslå **fördjupningsmöjligheter**, refactors som gör grunda moduler djupa. Målet är testbarhet och att AI ska kunna navigera koden.

Det här kommandot _informeras_ av projektets domänmodell och bygger på ett gemensamt designordförråd:

- Kör skillen `/codebase-design` för arkitekturvokabulären (**modul**, **interface**, **djup**, **söm**, **adapter**, **hävstång**, **lokalitet**) och dess principer (raderingstestet, "interfacet är testytan", "en adapter = hypotetisk söm, två = riktig"). Använd de termerna exakt i varje förslag. Glid inte över i "component", "service", "API" eller "boundary".
- Domänspråket i `docs/CONTEXT.md` ger namn åt bra sömmar; ADR:er i `docs/adr/` dokumenterar beslut som det här kommandot inte ska ta upp igen.

## Process

### 1. Utforska

**Avgränsa innan du skannar. YAGNI.** Att fördjupa en modul lönar sig genom att framtida ändringar i den blir enklare, så lägg extra vikt vid de delar av kodbasen som nyligen ändrats. Bestäm *var* du ska titta innan du tittar:

- Om användaren pekat ut en riktning, en modul, ett delsystem, en smärtpunkt, ta den och hoppa över slutledningen nedan.
- Annars, gå tillbaka en bra bit i commithistoriken (`git log --oneline`) för att hitta kodbasens hot spots, filerna och områdena som dyker upp om och om igen, och låt de sökvägarna dra din uppmärksamhet först. Om ändringarna är utspridda utan tydlig hot spot, vidga nätet.

Läs projektets domänglossarium (`docs/CONTEXT.md`) och eventuella ADR:er i området du rör först.

Starta sedan en subagent som går igenom kodbasen. Följ inte stela heuristiker. Utforska organiskt och notera var du upplever friktion:

- Var kräver förståelsen av ett koncept att man hoppar mellan många små moduler?
- Var är moduler **grunda**, interfacet nästan lika komplext som implementationen?
- Var har rena funktioner brutits ut bara för testbarhetens skull, medan de riktiga buggarna gömmer sig i hur de anropas (ingen **lokalitet**)?
- Var läcker hårt kopplade moduler över sina sömmar?
- Vilka delar av kodbasen är otestade, eller svåra att testa genom sitt nuvarande interface?

Tillämpa **raderingstestet** på allt du misstänker är grunt: skulle radering koncentrera komplexiteten, eller bara flytta den? Ett "ja, koncentrerar" är signalen du letar efter.

### 2. Presentera kandidaterna som en HTML-rapport

Skriv en självständig HTML-fil till operativsystemets temp-katalog så att inget hamnar i repot. Hämta temp-katalogen från `$TMPDIR`, med `/tmp` som fallback (eller `%TEMP%` på Windows), och skriv till `<tmpdir>/architecture-review-<timestamp>.html` så att varje körning får en ny fil. Öppna den åt användaren, `xdg-open <path>` på Linux, `open <path>` på macOS, `start <path>` på Windows, och berätta den absoluta sökvägen.

Rapporten använder **Tailwind via CDN** för layout och styling, och **Mermaid via CDN** för diagram där en graf, ett flöde eller en sekvens kommunicerar strukturen på ett pålitligt sätt. Blanda Mermaid med handgjorda CSS/SVG-visualiseringar. Använd Mermaid när relationerna är grafformade (anropsgrafer, beroenden, sekvenser), och handbyggda divs/SVG när du vill ha något mer redaktionellt (massdiagram, tvärsnitt, kollapsanimationer). Varje kandidat får en **före/efter-visualisering**. Var visuell.

För varje kandidat, rendera ett kort med:

- **Files**, vilka filer/moduler som är inblandade
- **Problem**, varför den nuvarande arkitekturen orsakar friktion
- **Solution**, beskrivning i vanlig prosa av vad som skulle ändras
- **Benefits**, förklarade i termer av lokalitet och hävstång, och hur testerna skulle bli bättre
- **Before / After diagram**, sida vid sida, egenritat, som illustrerar det grunda och fördjupningen
- **Recommendation strength**, en av `Strong`, `Worth exploring`, `Speculative`, renderad som en badge

Avsluta rapporten med en sektion **Top recommendation**: vilken kandidat du skulle ta dig an först och varför.

**Använd vokabulären i docs/CONTEXT.md för domänen, och vokabulären i `/codebase-design` för arkitekturen.** Om `docs/CONTEXT.md` definierar "Order", prata om "Order intake-modulen", inte "FooBarHandler", och inte "Order-servicen".

**ADR-konflikter**: om en kandidat motsäger en befintlig ADR, lyft bara fram den när friktionen är verklig nog att motivera att ADR:en tas upp igen. Markera det tydligt i kortet (t.ex. en varningsruta: _"motsäger ADR-0007, men värd att öppna igen eftersom…"_). Lista inte varje teoretisk refactor en ADR förbjuder.

Se [HTML-REPORT.md](HTML-REPORT.md) för hela HTML-skelettet, diagrammönster och stilguide.

Föreslå INTE interfaces ännu. När filen är skriven, fråga användaren: "Vilken av dessa vill du utforska?"

### 3. Grilling-loop

När användaren valt en kandidat, kör skillen `/grilling` för att gå igenom beslutsträdet tillsammans med dem: begränsningar, beroenden, formen på den fördjupade modulen, vad som sitter bakom sömmen, vilka tester som överlever.

Sidoeffekter sker inline allteftersom besluten kristalliseras. Kör skillen `/domain-modeling` för att hålla domänmodellen uppdaterad under tiden:

- **Döper en fördjupad modul efter ett koncept som inte finns i `docs/CONTEXT.md`?** Lägg till termen i `docs/CONTEXT.md`. Skapa filen vid behov om den inte finns.
- **Vässar en luddig term under samtalet?** Uppdatera `docs/CONTEXT.md` på en gång.
- **Användaren avvisar kandidaten med ett bärande skäl?** Erbjud en ADR, formulerat som: _"Vill du att jag dokumenterar det här som en ADR så att framtida arkitekturgranskningar inte föreslår det igen?"_ Erbjud bara när skälet faktiskt skulle behövas av en framtida utforskare för att undvika samma förslag igen. Hoppa över flyktiga skäl ("inte värt det just nu") och självklara.
- **Vill utforska alternativa interfaces för den fördjupade modulen?** Kör skillen `/codebase-design` och använd dess design-it-twice-mönster med parallella subagenter.
