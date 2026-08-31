---
name: to-tickets
description: Bryt ner en plan, spec eller den pågående konversationen till en uppsättning tracer-bullet-tickets, där varje ticket deklarerar vad som blockerar den, skrivna som en markdown-fil per ticket under docs/work/.
disable-model-invocation: true
---

# Till tickets

Bryt ner en plan, spec eller konversation till en uppsättning **tickets**. Vertikala tracer-bullet-slices, där varje ticket deklarerar vilka tickets som **blockerar** den.

Om repot har `docs/agents/issue-tracker.md` styr den filen var tickets bor och hur de skapas, läses, blockeras och stängs. Läs den först. Beskrivningarna av filer och sökvägar nedan gäller repon som saknar den.

Annars lever tickets som markdown-filer i repot: en fil per ticket i `tickets/` bredvid specen de kommer från, alltså `docs/work/<feature-slug>/tickets/`.

## Process

### 1. Samla kontext

Utgå från det som redan finns i konversationens kontext. Om användaren skickar en referens (en sökväg till en spec, ett issue-nummer eller en URL) som argument, hämta den och läs hela innehållet inklusive kommentarer.

### 2. Utforska kodbasen (valfritt)

Om du inte redan utforskat kodbasen, gör det för att förstå kodens nuläge. Tickettitlar och beskrivningar ska använda projektets domänordlista och respektera ADR:er i området du rör.

Leta efter möjligheter att prefaktorera koden så att implementationen blir enklare. "Make the change easy, then make the easy change."

### 3. Skissa vertikala slices

Bryt ner arbetet i **tracer bullet**-tickets.

<vertical-slice-rules>

- Varje slice skär en smal men KOMPLETT väg genom varje lager (schema, API, UI, tester). Vertikal, INTE en horisontell slice av ett lager
- En färdig slice går att demoa eller verifiera på egen hand
- Varje slice är dimensionerad för att rymmas i ett enda färskt kontextfönster
- All prefaktorering ska göras först

</vertical-slice-rules>

Ge varje ticket sina **blockeringar**, alltså de andra tickets som måste bli klara innan den kan börja. En ticket utan blockeringar kan börja direkt.

**Breda refaktoreringar är undantaget från vertikal slicing.** En **bred refaktorering** är en mekanisk ändring, byta namn på en kolumn, ändra typ på en delad symbol, vars **sprängradie** sprider sig över hela kodbasen, så att en enda ändring knäcker tusentals anropsställen på en gång och ingen vertikal slice kan landa grön. Tvinga inte in den i en tracer bullet. Sekvensera den som **expand-contract**. Först expand: lägg till den nya formen bredvid den gamla så inget går sönder. Sedan migrera anropsställena i batchar dimensionerade efter sprängradie (per paket, per katalog), varje batch sin egen ticket blockerad av expand, så CI hålls grön batch för batch eftersom den gamla formen fortfarande finns. Till sist contract: ta bort den gamla formen när ingen anropare finns kvar, i en ticket blockerad av varje migreringsbatch. När inte ens batcharna kan hålla sig gröna på egen hand, behåll sekvensen men låt dem dela en integrationsbranch som alla blockerar en avslutande integrera-och-verifiera-ticket. Grönt utlovas bara där.

### 4. Fråga ut användaren

Presentera den föreslagna nedbrytningen som en numrerad lista. För varje ticket, visa:

- **Title**: kort beskrivande namn
- **Blocked by**: vilka andra tickets (om några) som måste bli klara först
- **What it delivers**: det end-to-end-beteende den här ticketen får att fungera

Fråga användaren:

- Känns granulariteten rätt? (för grov / för fin)
- Är blockeringarna korrekta, beror varje ticket bara på tickets som faktiskt gatear den?
- Borde några tickets slås ihop eller delas ytterligare?

Iterera tills användaren godkänner nedbrytningen.

### 5. Skriv ticket-filerna

Skriv en fil per godkänd ticket på `docs/work/<feature-slug>/tickets/<NN>-<slug>.md`, numrerade från `01` i beroendeordning (blockerare först). Varje fils "Blocked by" listar numren/titlarna den beror på. Använd ticket-mallen nedan. En ticket per fil, aldrig en enda sammanslagen fil.

Jobba på **frontlinjen**: varje ticket vars blockerare alla är klara. En mergad tickets fil raderas, så en "Blocked by" som pekar på en fil som inte längre finns är uppfylld. För en helt linjär kedja betyder det uppifrån och ner.

Stäng INTE och ändra INTE någon överordnad spec eller ticket.

<ticket-template>

# <NN> — <Ticket title>

**What to build:** det end-to-end-beteende den här ticketen får att fungera, ur användarens perspektiv. Inte en lager-för-lager-lista över implementationen.

**Blocked by:** numren/titlarna på de tickets som gatear den här, eller "None — can start immediately".

- [ ] Acceptanskriterium 1
- [ ] Acceptanskriterium 2

</ticket-template>

Undvik specifika filsökvägar och kodsnuttar. De blir inaktuella snabbt. Undantag: om en prototyp producerat en snutt som fångar ett beslut mer exakt än prosa kan (state machine, reducer, schema, typform), lägg in den inline och notera kort att den kommer från en prototyp. Skala ner till de beslutsrika delarna. Ingen fungerande demo, bara det viktiga.
