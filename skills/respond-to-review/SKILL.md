---
name: respond-to-review
description: Responds to review and updates llm_stuff/prs/<current-branch>/REVIEW_CONTEXT.md
disable-model-invocation: true
---

Jag kommer att svara på alla (eller några) av dina punkter med tre olika alternativ.
Antingen fixa, ignorera eller en följdfråga.
- Börja med att implementera alla fixar först, en i taget.
- Kolla sedan på allting jag sade åt dig att ignorera på något sätt.
  Lägg till dom grejerna i `docs/prs/<current-branch>/REVIEW_CONTEXT.md` (skapa filen och mappen om den inte finns) så att nästa person som reviewar inte behöver ta upp samma saker igen.
  Du behöver inte lägga till nånting om supersmå nitpicks och sånt som jag sa åt dig att ignorera.
  Du behöver heller inte nämna någonting om dina fixar i den, det kommer ju redan vara fixat när nästa person reviewar.
- Till sist, gör en tabell där du svarar på alla frågor jag har ställt och allting som jag tyckte var oklart.
  Ta en fråga i taget och verifiera mot koden innan du svarar på dom, det gör inget om det tar en stund.
  Skriv också om det är någon av de andra punkterna där du tycker att jag har fel, kanske att jag har missat något.


När vi är helt klara (jag har fått svar på alla mina frågor, kanske ställt följdfrågor och vi kanske har fixat lite saker beroende på dom) och det inte finns något kvar för mig att ta ställning till:
- kolla i /home/hector/REVIEW_COMMENTS.md och lägg en lista där på allting som du har fixat och allt som ignorerades i det här pr:et, den ska ha tre rubriker "### Fixade", "### Ignorerade" och "### Fixade med modifikation" som ligger under en rubrik för hela pr.et.
  Om den redan finns för det här pr:et så lägg till dom grejerna vi tog upp i den här review rundan. Ta inte med de kommentarer som du själv filtrerade bort, bara dom jag sa (eller dom vi kom fram till) skulle ignoreras.
