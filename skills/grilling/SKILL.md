---
name: grilling
description: Grilla användaren skoningslöst om en plan, ett beslut eller en idé. Använd när användaren vill stresstesta sitt tänkande eller använder någon 'grill'-triggerfras.
---

Intervjua användaren skoningslöst tills ni nått en gemensam förståelse. Kartlägg det som ett **designträd**: varje beslut förgrenar sig i de beslut som hänger på det.

Jobba igenom trädet i **rundor**. **Frontlinjen** är varje beslut vars förutsättningar redan är avgjorda, alltså de frågor du kan ställa _nu_ utan att gissa svar du inte hört än. Ställ hela frontlinjen i en runda: numrera varje fråga och ge ditt rekommenderade svar. Vänta sedan på användarens svar innan nästa runda.

Varje fråga ska formateras så här:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Varje runda användaren svarar på formar om trädet. Avgjorda beslut flyttar frontlinjen utåt och låser upp frågor som berodde på dem. Räkna om frontlinjen och ställ nästa runda. En fråga vars svar beror på en annan fråga som fortfarande är öppen i den här rundan hör till en _senare_ runda, inte den här.
Du får ha max 5 frågor per runda. Färre ju mer komplexa och/eller osäkra de är.

Att hitta _fakta_ är ditt jobb, aldrig användarens. När en fråga på frontlinjen kräver ett faktum från miljön (filsystemet, verktyg osv.), skicka iväg en sub-agent för att hitta det. Fråga inte användaren om något du kan slå upp själv. Blockera inte på det: en pågående utforskning är en oavgjord förutsättning, så bara frågorna nedströms väntar på att sub-agenten rapporterar. Ställ resten av frontlinjen nu. _Besluten_ är användarens. Lägg fram vart och ett och vänta.

Sessionen är klar när frontlinjen är tom: varje gren i designträdet besökt, inget lämnat som tyst antagande. Agera inte på den förrän användaren bekräftat att ni nått en gemensam förståelse.

Om användaren ber dig synka grillsessionen till en fil, skriv den till `docs/work/<slug>/grilling.md`. Spec och tickets hamnar i samma mapp, så välj den slug de kommer använda. Om sessionen visar sig täcka flera features stannar grillningen i den roten och features blir undermappar bredvid den. Fall tillbaka på ett beskrivande namn när grillningen inte hör till en feature. Om filen redan finns, lägg till i den. Skriv den som en lista med frågor och svar under # Questions and Answers.
Om du också gjort research eller på annat sätt fått fram relevant information som inte lätt hittas i repot, skriv en sektion # Research för den informationen också.
Poängen med filen är att bära rådatan från allt vi kommit fram till under sessionen på ett koncist sätt.
