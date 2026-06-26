---
name: respond-to-review
description: Responds to review and updates docs/prs/<branch-slug>/review-data.js
disable-model-invocation: true
---

Jag kommer att svara på alla (eller några) av dina punkter med tre olika alternativ.
Antingen fixa, ignorera eller en följdfråga.
- Börja med att implementera alla fixar först, en i taget.
- Uppdatera sedan `docs/prs/<branch-slug>/review-data.js` så att review-punkternas status matchar vad som hände:
  - Punkter du fixade ska få `status: "implemented"`.
  - Punkter användaren sade att vi ska ignorera ska få `status: "ignored"` och en tydlig `ignoreReason`.
  - Punkter som fortfarande behöver hanteras ska vara kvar som `status: "pending"` eller sakna status, eftersom `pending` är default.
  - Ändra bara status/ignore reason för punkter som faktiskt behandlades i den här responsen.
- `review-data.js` ska fortsätta vara strikt JSON-kompatibel JavaScript: `window.reviewData = { ... };` med quoted keys, inga comments och inga trailing commas i objektet.
- För varje punkt som nyligen sätts till `status: "ignored"`:
  - Se till att findingen har `files` med repo-relativa filpaths utan radnummer. Om det saknas, härled det från `location`.
  - Se till att findingen har en stabil `fingerprint`, byggd från agent/kategori, primär fil och normaliserad issue-titel.
  - Append:a en rad till `docs/prs/_review-index/ignored-findings.jsonl` med eventet. Skapa katalogen/filen om den saknas.
  - Append:a inte en dublett om samma `pr`, `findingId`, `fingerprint` och `event: "ignored"` redan finns.
- JSONL-raden ska vara ett JSON-objekt på en rad:

```json
{"event":"ignored","pr":"<branch-slug>","findingId":3,"files":["src/foo.ts"],"fingerprint":"bug-reviewer:src/foo.ts:null-user-id","agents":["bug-reviewer"],"title":"...","problem":"...","ignoreReason":"...","ignoredAt":"2026-06-26T08:04:00Z"}
```

- Om en punkt ändras från `ignored` till något annat, append:a i stället ett `event: "unignored"` med samma `pr`, `findingId`, `fingerprint` och en `changedAt` timestamp. Ta inte bort gamla JSONL-rader.
- Implementera inte punkter där användaren ställde än fråga, även om den är ledande.
- Till sist, gör en tabell där du svarar på alla frågor jag har ställt och allting som jag tyckte var oklart.
  Ta en fråga i taget och verifiera mot koden innan du svarar på dom, det gör inget om det tar en stund.
  Skriv också om det är någon av de andra punkterna där du tycker att jag har fel, kanske att jag har missat något.
