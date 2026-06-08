---
name: respond-to-review
description: Responds to review and updates docs/prs/<branch-slug>/review.html
disable-model-invocation: true
---

Jag kommer att svara på alla (eller några) av dina punkter med tre olika alternativ.
Antingen fixa, ignorera eller en följdfråga.
- Börja med att implementera alla fixar först, en i taget.
- Uppdatera sedan `docs/prs/<branch-slug>/review.html` så att review-punkternas status matchar vad som hände:
  - Punkter du fixade ska få `status: "implemented"`.
  - Punkter användaren sade att vi ska ignorera ska få `status: "ignored"` och en tydlig `ignoreReason`.
  - Punkter som fortfarande behöver hanteras ska vara kvar som `status: "pending"` eller sakna status, eftersom `pending` är default.
  - Ändra bara status/ignore reason för punkter som faktiskt behandlades i den här responsen.
- Till sist, gör en tabell där du svarar på alla frågor jag har ställt och allting som jag tyckte var oklart.
  Ta en fråga i taget och verifiera mot koden innan du svarar på dom, det gör inget om det tar en stund.
  Skriv också om det är någon av de andra punkterna där du tycker att jag har fel, kanske att jag har missat något.


När vi är helt klara (jag har fått svar på alla mina frågor, kanske ställt följdfrågor och vi kanske har fixat lite saker beroende på dom) och det inte finns något kvar för mig att ta ställning till:
- skriv eller uppdatera `docs/prs/<branch-slug>/responses/<review-id>.md` och lägg en lista där på allting som du har fixat och allt som ignorerades i den här review-rundan. `<review-id>` ska matcha review-mappen, t.ex. `review-001.md`.
  Den ska ha tre rubriker "### Fixade", "### Ignorerade" och "### Fixade med modifikation" som ligger under en rubrik för hela review-rundan.
  Om den redan finns för det här pr:et så lägg till dom grejerna vi tog upp i den här review rundan. Ta inte med de kommentarer som du själv filtrerade bort, bara dom jag sa (eller dom vi kom fram till) skulle ignoreras.
