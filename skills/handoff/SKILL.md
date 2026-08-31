---
name: handoff
description: Komprimera nuvarande konversation till ett handoff-dokument som en annan agent kan ta över.
argument-hint: "Vad ska nästa session användas till?"
disable-model-invocation: true
---

Skriv ett handoff-dokument som sammanfattar nuvarande konversation så att en ny agent kan fortsätta arbetet. Spara det i temp-katalogen för användarens OS, inte i nuvarande workspace.

Ta med en sektion "suggested skills" i dokumentet som föreslår vilka skills agenten bör anropa.

Duplicera inte innehåll som redan finns i andra artefakter (PRD:er, planer, ADR:er, issues, commits, diffar). Referera till dem med sökväg eller URL istället.

Maska känslig information, som API-nycklar, lösenord eller personuppgifter.

Om användaren skickade med argument, tolka dem som en beskrivning av vad nästa session ska fokusera på och anpassa dokumentet efter det.
