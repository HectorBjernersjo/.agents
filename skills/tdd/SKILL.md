---
name: tdd
description: Testdriven utveckling. Använd när användaren vill bygga features eller fixa buggar test-först, nämner "red-green-refactor" eller vill ha integrationstester.
---

# Testdriven utveckling

TDD är loopen red → green. Den här skillen är referensen som gör att loopen producerar tester värda att behålla: vad ett bra test är, var tester hör hemma, anti-mönstren och loopens regler. Varje avsnitt gäller i varje cykel. Läs dem före och under loopen, inte efteråt.

När du utforskar kodbasen, läs `docs/CONTEXT.md` (om den finns) så att testnamn och vokabulären i gränssnitten matchar projektets domänspråk, och respektera ADR:er i området du rör.

## Vad ett bra test är

Tester verifierar beteende genom publika gränssnitt, inte implementationsdetaljer. Koden kan bytas ut helt utan att testerna behöver ändras. Ett bra test läses som en spec. "user can checkout with valid cart" säger exakt vilken förmåga som finns, och testet överlever refaktoreringar eftersom det inte bryr sig om intern struktur.

Se [tests.md](tests.md) för exempel och [mocking.md](mocking.md) för riktlinjer kring mockning.

## Seams, där testerna hör hemma

En **seam** är den publika gränsen du testar vid: gränssnittet där du observerar beteende utan att gräva i insidan. Tester lever vid seams, aldrig mot interna delar.

**Testa bara vid seams ni kommit överens om i förväg.** Innan du skriver något test, skriv ner vilka seams som ska testas och bekräfta dem med användaren. Inget test skrivs vid en obekräftad seam. Du kan inte testa allt. Att komma överens om seams i förväg är det som gör att testarbetet hamnar på kritiska flöden och komplex logik istället för på varje edge case.

Fråga: "Vad är det publika gränssnittet, och vilka seams ska vi testa?"

När formen på gränssnittet i sig är oklar, hur djup modulen ska vara, var seamen hör hemma, vad gränssnittet ska exponera, använd skillen `/codebase-design` för vokabulären. Den är den gemensamma källan för termerna modul, gränssnitt, djup, seam, adapter, leverage och locality, och den är en referens att slå i, inte en session att köra.

## Anti-mönster

- **Implementationskopplat**. Mockar interna samarbetspartners, testar privata metoder eller verifierar via en sidokanal (frågar databasen istället för att använda gränssnittet). Tecknet: testet går sönder när du refaktorerar trots att beteendet inte ändrats.
- **Tautologiskt**. Assertionen räknar fram det förväntade värdet på samma sätt som koden gör (`expect(add(a, b)).toBe(a + b)`, en snapshot härledd för hand på samma sätt, en konstant som assertas lika med sig själv), så testet passerar per konstruktion och kan aldrig säga emot koden. Förväntade värden måste komma från en oberoende sanningskälla: en känd korrekt literal, ett genomräknat exempel, specen.
- **Horisontell slicing**. Att skriva alla tester först och sedan all implementation. Tester i bulk verifierar _inbillat_ beteende: du testar _formen_ på saker istället för beteende som användaren ser, testerna blir okänsliga för verkliga ändringar och du låser fast teststrukturen innan du förstått implementationen. Jobba i **vertikala slices** istället. Ett test → en implementation → upprepa, där varje test är en **tracer bullet** som svarar på det förra cykeln lärde dig.

## Loopens regler

- **Red före green.** Skriv det fallerande testet först, sedan bara så mycket kod som krävs för att det ska passera. Föregrip inte framtida tester och lägg inte till spekulativa features.
- **En slice i taget.** En seam, ett test, en minimal implementation per cykel.
- **Refaktorering är inte en del av loopen.** Den hör hemma i granskningssteget (se skillen `code-review`), inte i implementationscykeln red → green.
