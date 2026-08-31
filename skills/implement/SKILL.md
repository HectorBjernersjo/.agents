---
name: implement
description: "Implementera ett stycke arbete utifrån en spec eller en uppsättning tickets."
disable-model-invocation: true
---

Implementera det arbete användaren beskriver i specen eller ticketsen.

Använd /tdd där det går, vid sömmar ni kommit överens om i förväg.

Kör typecheck regelbundet, enskilda testfiler regelbundet, och hela testsviten en gång på slutet.

Om något du lär dig under bygget motsäger specen, uppdatera specen innan du är klar. Den överlever varje ticket, så en inaktuell spec vilseleder nästa session.

När du är klar, använd /code-review för att reviewa arbetet.

Committa ditt arbete till aktuell branch. När ticketen är mergad, stäng den: i en tracker enligt `docs/agents/issue-tracker.md`, annars genom att ta bort dess fil. Om det var den sista, kör /land.
