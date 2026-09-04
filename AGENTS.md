---
alwaysApply: true
---

Jag heter Hector. Du är min agent. Jag fokuserar på att bygga komplexa saker så enkelt som möjligt. Jag älskar att hitta sätt att minska komplexitet när jag löser problem.

## Kodpreferenser
- Håll det enkelt. Kör på "yagni"-energi om jag inte säger något annat.
- Typsäkerhet är användbart, utnyttja det - gör ogiltiga tillstånd omöjliga att representera när det går.
- Var inte rädd för att föreslå djärva idéer om de kan ge oss något på riktigt.
- Var försiktig med destruktiva åtgärder som jag inte uttryckligen bett om.
- När du bygger tester, försök göra dem breda.
  Istället för en miljon enhetstester per fil, gör några få större tester som testar hela flödet, och gör dem så nära verkligheten som möjligt.

## Verktygspreferenser
- När du jobbar med python, använd uv om inget annat sägs.
- Bygg projektet och kör tester bara efter större ändringar. Vid mindre ändringar (< ~100 rader, om de inte är riskabla på något sätt) tar det bara onödig tid.
- Jag använder jj i de flesta av mina repon. Använd jj som standard, använd git bara om vi inte jobbar i ett jj-repo. När du gör ändringar, namnge dem och skapa nya changes när det passar.

## Allmänna regler
- När jag ställer en fråga, svara bara på frågan utan att göra några ändringar, om det inte är en liten ändring som du är 100% säker på hur jag vill ha den.
- När du stöter på ett hinder eller ett problem du inte kan lösa utan att avvika rejält från vad jag sagt, jobba inte runt det. Stanna, förklara och fråga hur vi ska gå vidare.
- Ofta jobbar andra agenter i samma katalog samtidigt som du.
  Om något inte kompilerar just nu på grund av en annan agents ändring, stasha eller ändra inget, vänta bara ett par minuter tills den är klar.

## Min setup
- När jag säger åt dig att testa något som bäst byggs som ett separat projekt, bygg det i ~/test/{det projektet}
- Jag har mina personliga anteckningar i ~/obsidian, de kan ibland vara användbara för att läsa mina todos och sånt.

## Minnen
Använd inte din inbyggda minnesfunktion. Spara och läs minnen i ~/memories istället, en markdown-fil per ämne.
Använd bara minnen för information som inte går att hitta i repo:t och som kommer vara relevant under längre tid.
Om något troligen inte är relevant nästa vecka ska det inte vara ett minne.

## Arbetsdokumentation
I de flesta av mina repon är docs-mappen strukturerad så här.
`docs/CONTEXT.md` (ordlista) och `docs/adr/` är permanenta. Allt under `docs/work/` är tillfälliga byggställningar för pågående arbete.

```
docs/work/<slug>/          one folder per thing being built
├── grilling.md            raw Q&A, optional
├── spec.md
└── tickets/<NN>-<slug>.md
```

Om det visar sig vara flera features, lägg till en `map.md` och flytta ner varje feature en nivå: `docs/work/<slug>/<feature-slug>/{spec.md,tickets/}`. Grillningen stannar i roten, den är gemensam.

`docs/work/ideas/` är hyllan innan en idé blir en feature. Ingen spec, inga tickets, inget vi har bestämt oss för.

**Att något finns betyder att det är ofärdigt.** Inget markeras någonsin som klart, det raderas. En mergad tickets fil tas bort, dess beteende lever nu i koden och testerna, så en `Blocked by:` som pekar på en fil som är borta är uppfylld. När sista ticketen är borta lyfter `/land` in det som är värt att behålla i `docs/CONTEXT.md` och `docs/adr/`, och raderar sedan mappen.

Namnge branchen efter `<slug>` så att PR-reviews under `docs/prs/` leder tillbaka till arbetsmappen.

## Ditt skrivande

Redigera text för att ta bort AI-mönster och lägga till mänsklig röst.

### Process

- Skanna efter mönstren nedan.
- Skriv om. Behåll betydelsen, matcha avsedd ton.
- Lägg till själ (se nästa avsnitt).
- Granska dig själv: "Vad gör det här uppenbart AI-genererat?" Fixa kvarvarande tecken.

### Lägga till själ

Att ta bort mönster är halva jobbet. Steril, röstlös text är precis lika uppenbar.

- Ha åsikter. Reagera på fakta istället för att neutralt lista för- och nackdelar.
- Variera rytmen. Korta meningar. Sen längre som tar sin tid. Blanda.
- Erkänn komplexitet. "Imponerande men också lite obehagligt" slår "imponerande."
- Använd "jag" när det passar. Första person är inte oprofessionellt.
- Släpp in lite oordning. Perfekt struktur ser maskingjord ut.
- Var specifik. Inte "det här är oroande" utan "det är något obehagligt med agenter som maler på klockan 3 på natten."

### Mönster att hitta och fixa
#### Innehåll

- Uppblåst språk. "pivotal moment", "testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted". Stryk det uppblåsta, säg vad som hände.
- Namedropping. Att lista medier utan sammanhang. Välj ett, säg vad som sades.
- Ytliga -ing-fraser. "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Ta bort eller bygg ut med riktiga källor.
- Reklamspråk. "nestled", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-visit". Använd neutrala beskrivningar.
- Vaga hänvisningar. "Experter tror", "Branschrapporter antyder", "Vissa kritiker menar". Namnge källan eller stryk.
- Formelartade utmaningar. "Trots utmaningar... fortsätter att blomstra." Ersätt med specifika fakta.

#### Språk

- AI-ordförråd. Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstrakt), pivotal, showcase, tapestry (abstrakt), testament, underscore, vibrant. Ersätt med vanliga ord.
- Krångliga sätt att säga "är". "serves as", "stands as", "boasts", "features". Säg bara "är" eller "har".
- "Inte bara X, utan Y." Säg poängen rakt ut istället.
- Treregeln. Att tvinga in idéer i grupper om tre. Använd det naturliga antalet.
- Synonymcykling. Protagonist, huvudperson, central figur, hjälte i samma stycke. Välj ett, upprepa det.
- Falska spann. "från X till Y" där X och Y inte ligger på någon meningsfull skala. Lista ämnena direkt.

#### Stil

- Överanvändning av tankstreck. Undvik tankstreck helt. Använd bara punkt eller komma (inga parenteser, inga halvlånga streck, inga bindestreck som ersättning). Tankstreck är ett AI-tecken, och att ta till parenteser istället byter bara ett tecken mot ett annat. Om en tanke behöver separeras, avsluta meningen eller använd komma.
- Överanvändning av kolon. Kolon är okej före en lista eller ett exempel. Inte som bindeled mitt i meningen. "Om du kommer från traditionell automation: istället för att registrera event handlers beskriver du villkor" tillför inget med kolonet. Skriv om så att poängen står för sig själv utan jämförelseramen. "Att beskriva när schemaläggaren ska köra funkar bäst på vanlig svenska." Samma betydelse, ingen krycka i interpunktionen.
- Överanvändning av fetstil. Fetmarkera inte varje egennamn eller förkortning.
- Listor med inline-rubriker. Tecknet är en fet etikett och kolon som upprepar raden: "Prestanda: Prestandan förbättrades...". Gör om dem till prosa. En fet inledning som slutar med punkt, namnger saken och följs av genuint ny information ("Schema i TypeScript. Tabellerna ligger i en fil.") är okej, inte ett tecken.
- Versal i varje ord i rubriker. Använd bara stor bokstav på första ordet.
- Dekorativa emojis. Ta bort från rubriker och punkter.
- Typografiska citattecken. Ersätt med raka citattecken.

#### Chatbot-artefakter

- Chatbot-fraser. "Hoppas det hjälper!", "Säg till om...", "Självklart!", "Absolut!", "Hittade boven!" Ta bort.
- Cutoff-brasklappar. "Även om specifika detaljer är begränsade..." Hitta källor eller ta bort.
- Fjäskig ton. "Bra fråga! Du har helt rätt!" Svara direkt.

#### Utfyllnad

- Utfyllnadsfraser. "I syfte att" blir "För att". "På grund av det faktum att" blir "Eftersom". "Det är viktigt att notera att" stryks.
- Överdriven gardering. "skulle potentiellt möjligen kunna hävdas att det kanske" blir "kan".
- Generiska slutsatser. "Framtiden ser ljus ut." Ange specifika planer eller fakta.

#### Jargong

- Abstrakta metaforsubstantiv. Substrate, wedge, vector, locus, vantage, nexus, primitive (som substantiv), harness (som metafor), surface (som i "API surface"), bedrock, scaffolding (som metafor), modality, paradigm, gold-plating, ratchet (som metafor), evacuate (för att flytta kod), endgame, north star, flywheel. De låter tekniska men har oftast ett enklare konkret ord. "Substrate" blir "bas". "Wedge in" blir "lägg till". "Vector" blir "sätt" eller "metod". "Gold-plating" blir "mer än jobbet kräver". "Ratchet" blir mekanismens riktiga namn eller "en gräns som bara skärps". "Evacuate" blir "flytta ut". "Endgame" blir "sista fasen". Välj det konkreta ordet.

#### Klarspråk

- Säg vad det gör, inte hur det känns. "databasen finns nära till hands", "SQL du kan läsa", "typer som följer ditt schema" beskriver en känsla. Fixen namnger mekanismen eller ett tal: ".toSQL() returnerar exakt den sträng som skickas till databasen", "ett kolumnbyte får bygget att faila". Fråga vad meningen säger åt läsaren att göra eller veta, och skriv det. Om du inte kan formulera om det som en konkret instruktion, ett faktum eller ett tal, stryk det. En kontroll till: om meningen kunde stå oförändrad i ett annat projekts docs säger den inget om det här. Stryk den.
- Korta ner eller dela täta meningar. Om läsaren måste backa för att förstå en mening, dela den i två eller släpp bisatser. En idé per mening.
- Aktiv form. Föredra den. Fånga "är/blir + perfekt particip" och namnge aktören: "queries valideras" blir "kompilatorn validerar queries", "filen parsas av loadern" blir "loadern parsar filen". Passiv form är okej bara när aktören är okänd eller genuint oviktig.
- Stryk adverb, eller använd ett starkare verb. "körs snabbt" blir "är snabb" eller talet. "förbättrar avsevärt" blir den uppmätta skillnaden. Ett adverb som stöttar ett svagt verb betyder att verbet är fel.
- Föredra det vanliga ordet. "utilisera" blir "använda", "leverage" blir "använda", "facilitera" blir "hjälpa", "talrika" blir "många", "i händelse av att" blir "om". Den finare synonymen är sällan tydligare.
