---
name: user-story
description: Creates a user story from the current pr
disable-model-invocation: true
---

Användaren vill ha hjälp med att skapa en user story från deras pr, användaren kommer att säga vilket pr de vill ha hjälp med.

Om du ska göra för det här pret:
- Kör git diff master... för att se vad den här pr:en har gjort.
Om du ska göra för ett annat pr:
- Gör git --no-pager log --author="Hector Bjernersjö", 
- Leta upp vilken commit som verkar matcha bäst med den användaren vill ha
- Gör sen git --no-pager show {den committen}

User storyn ska innehålla följande
- Namn
- Description
- Acceptance criteria
- Release note
- Riskanalys
- PR description

Här kommer lite instruktioner för hur du ska skriva dem:

## User story Description

## Acceptance criteria

## Release Note
Skriv en release note för det här pr:et, den ska vara på engelska och ha en header (bara några ord) och en text (max en till några meningar)
Fokusera bara på vad som ändras för användaren, ingenting tekniskt.

## Riskanalys

Skriv en riskanalys för den här pr:en, den ska ha siffrorna:
- Risk impact (1 - 3, tre är högt)
- Risk likelihood (1 - 3, tre är högt)
- Risk (3 - 0, 3 är low, 2 är medium, 1 är high, 0 är critical)

Sen så ska vi ha en text på några meningar som försvarar det vi har valt.
Skriv inte om specifika kodändringar.

Här är några exempel:

---

Low
Ingen större risk, vi samman kopplar ett vy element som ska användas som filter till en grid med 2-10 arbeten. Detta filter element kommer då att filtrera listan. Påverkar ingen existerande data eller
funktion som används av kund.
Om något går fel nu så märkts det snabbt och tydligt, vi är i beta steget så vi hare gott om tid att se över eventuella problem

---

Medium
Vi ändrar valideringen när vi sparar Visma Connect epost på en användare. Den ska nu strunta i allfoner.
Risken är att något med queryn går sönder, och folk inte längre då kan spara eller skapa en användare i vissa case.

Test täcker basfallen och testning sker under utveckling. Om något fel slinker igenom så är det edge cases.

---

Low
Vi skapar en ny komponent vars syfte är att fungera som en knapp eller en presentation av data. Innebär inga risker för drift, data eller förstörelse av andra delar av systemet.

Möjligtvis att komponenten kan ta sönder vyn de läggs till i.
Möjligtvis att stylingen för den påverkar masterstyle filen som då tar sönder hela hrm:s styling. Men e2e testerna fångar detta, och även unittest som kollar så att rätta variabler används i
ds-theme.less.

---

Low

Ren refaktorering och städning av chatbot-koden. Ingen ny funktionalitet, ingen databasändring, inget ändrat beteende. Duplicerad kod konsolideras och kodstil moderniseras.

Det viktigaste: att man kan skicka en fråga, att den söker i dokumentationen och ger ett svar, fungerar som innan. Jag har testat att det fungerar innan PR:en skickades upp. Om något ändå skulle gå fel
påverkas bara chatboten, ingen annan del av systemet.

---


Om pr:en gäller chatboten är det allmänt så att det viktigaste att det funkar är att det går att skicka en fråga, att den söker i dokumentationen och ger ett svar.
Jag testar innan jag skickar upp varje pr att det fungerar.
Chatboten är ute i prod så skriv inget om någon feature flag.


## Pr description
Fokusera på varför det är gjort som det är och beskriv i bredare drag.


## Vilket pr


(Om det inte står något pr här så kör på det nuvarande pret)
Det pr du ska göra riskanalys för är:
