# Design it twice

När användaren vill utforska alternativa interface för en vald fördjupningskandidat, använd det här mönstret med parallella sub-agenter. Bygger på "Design It Twice" (Ousterhout). Din första idé är sällan den bästa.

Använder ordförrådet i [SKILL.md](SKILL.md): **modul**, **interface**, **söm**, **adapter**, **hävstång**.

## Process

### 1. Rama in problemrymden

Innan du startar sub-agenter, skriv en förklaring av problemrymden för den valda kandidaten, riktad till användaren:

- Begränsningarna ett nytt interface skulle behöva uppfylla
- Beroendena det skulle luta sig mot, och vilken kategori de tillhör (se [DEEPENING.md](DEEPENING.md))
- En grov illustrerande kodskiss som gör begränsningarna konkreta. Inget förslag, bara ett sätt att göra dem greppbara

Visa det här för användaren och gå sedan direkt vidare till steg 2. Användaren läser och tänker medan sub-agenterna jobbar parallellt.

### 2. Starta sub-agenter

Starta 3+ sub-agenter parallellt. Var och en ska producera ett **radikalt annorlunda** interface för den fördjupade modulen.

Ge varje sub-agent en separat teknisk brief (filsökvägar, kopplingsdetaljer, beroendekategori från [DEEPENING.md](DEEPENING.md), vad som ligger bakom sömmen). Briefen är oberoende av problemrymdsförklaringen till användaren i steg 1. Ge varje agent en egen designbegränsning:

- Agent 1: "Minimera interfacet. Sikta på max 1 till 3 ingångspunkter. Maximera hävstång per ingångspunkt."
- Agent 2: "Maximera flexibilitet. Stöd många användningsfall och utbyggnad."
- Agent 3: "Optimera för den vanligaste anroparen. Gör standardfallet trivialt."
- Agent 4 (om tillämpligt): "Designa kring ports & adapters för beroenden som korsar sömmen."

Ta med både ordförrådet i [SKILL.md](SKILL.md) och ordförrådet i docs/CONTEXT.md i briefen så att varje sub-agent namnger saker konsekvent med arkitekturspråket och projektets domänspråk.

Varje sub-agent levererar:

1. Interface (typer, metoder, parametrar, plus invarianter, ordning, felfall)
2. Användningsexempel som visar hur anropare använder det
3. Vad implementationen gömmer bakom sömmen
4. Beroendestrategi och adaptrar (se [DEEPENING.md](DEEPENING.md))
5. Avvägningar. Var hävstången är hög, var den är tunn

### 3. Presentera och jämför

Presentera designerna en i taget så att användaren hinner ta in var och en, jämför dem sedan i löpande text. Ställ dem mot varandra på **djup** (hävstång vid interfacet), **lokalitet** (var ändringar samlas) och **sömplacering**.

Ge sedan din egen rekommendation: vilken design du tycker är starkast och varför. Om delar från olika designer skulle passa ihop, föreslå en hybrid. Ha åsikter. Användaren vill ha en tydlig bedömning, inte en meny.
