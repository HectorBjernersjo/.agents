---
name: to-spec
description: Gör om den pågående konversationen till en spec och skriv den till docs/work/. Ingen intervju, bara en syntes av det ni redan diskuterat.
disable-model-invocation: true
---

Den här skillen tar den pågående konversationens kontext och förståelsen av kodbasen och producerar en spec. Intervjua INTE användaren. Syntetisera bara det du redan vet.

Specar lever som markdown-filer i repot: `docs/work/<feature-slug>/spec.md`. Om arbetet redan har en `map.md` (flera features under ett gemensamt arbete) skriver du istället till `docs/work/<effort-slug>/<feature-slug>/spec.md`.

## Process

1. Utforska repot för att förstå kodbasens nuläge, om du inte redan gjort det. Använd projektets domänordlista genomgående i specen och respektera ADR:er i området du rör.

2. Skissa de seams du kommer testa featuren vid. Befintliga seams ska föredras framför nya. Använd högsta möjliga seam. Om nya seams behövs, föreslå dem så högt upp du kan. Ju färre seams i kodbasen, desto bättre. Det ideala antalet är en.

Stäm av med användaren att de här seams matchar deras förväntningar.

3. Skriv specen med mallen nedan och skapa katalogen om den behövs. Återanvänd slugen från en befintlig `grilling.md` när specen kommer ur en sådan. Lägg inte till någon statusrad. Att filen finns betyder att arbetet inte är klart.

<spec-template>

## Problem Statement

Problemet användaren har, ur användarens perspektiv.

## Solution

Lösningen på problemet, ur användarens perspektiv.

## User Stories

En LÅNG, numrerad lista med user stories. Varje user story ska ha formatet:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

Listan med user stories ska vara extremt omfattande och täcka alla aspekter av featuren.

## Implementation Decisions

En lista med implementationsbeslut som tagits. Det kan innefatta:

- Modulerna som ska byggas/ändras
- Gränssnitten i de modulerna som ska ändras
- Tekniska förtydliganden från utvecklaren
- Arkitekturbeslut
- Schemaändringar
- API-kontrakt
- Specifika interaktioner

Ta INTE med specifika filsökvägar eller kodsnuttar. De kan bli inaktuella väldigt snabbt.

Undantag: om en prototyp producerat en snutt som fångar ett beslut mer exakt än prosa kan (state machine, reducer, schema, typform), lägg in den inline under det relevanta beslutet och notera kort att den kommer från en prototyp. Skala ner till de beslutsrika delarna. Ingen fungerande demo, bara det viktiga.

## Testing Decisions

En lista med testbeslut som tagits. Ta med:

- En beskrivning av vad som gör ett bra test (testa bara externt beteende, inte implementationsdetaljer)
- Vilka moduler som ska testas
- Prior art för testerna (dvs. liknande typer av tester i kodbasen)

## Out of Scope

En beskrivning av det som ligger utanför scope för den här specen.

## Further Notes

Eventuella ytterligare anteckningar om featuren.

</spec-template>
