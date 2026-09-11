# Steg 5

Skriv till sist den slutliga listan över punkter du tyckte var värda att implementera till:

```text
docs/prs/<branch-slug>/reviews/<review-id>/architecture/report.md
```

Det här är den enda delen av arkitektur-reviewen som implementeraren faktiskt kommer läsa, så se till att varje punkt har en bra beskrivning av problemet och en enda, mycket detaljerad och konkret fix.

En eller två rader räcker förmodligen inte. Beskriv exakt hur du skulle lösa det:

- Vilka klasser och funktioner behöver ändras?
- Behöver vi lägga till eller ta bort några datamodeller?
- Hur ska de datamodellerna se ut?
- Vad ska flyttas, döpas om, delas upp eller tas bort?

Det är okej om du upprepar en del av det du skrev i de andra delarna. Det viktiga är att ta med en enda konkret fix utan tvetydigheter.

När rapporten är klar, rapportera tillbaka till huvud-review-agenten med:

- Sökvägen till `report.md`.
- En kort sammanfattning av varje punkt i rapporten.
