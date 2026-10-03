När användaren svarar på review-findings, hantera fixarna först och uppdatera sedan `<review-root>/<branch-slug>/review-data.js`.

Användaren kan svara på varje finding med ett av följande:

- fix
- ignore
- följdfråga

För fixar:

- Implementera dem en i taget.
- Sätt findingen till `status: "implemented"`.

För ignores:

- Sätt findingen till `status: "ignored-by-human"`.
- Lägg till en tydlig `ignoreReason`.
- Se till att findingen har `files` med repo-relativa sökvägar utan radnummer. Om de saknas, ta fram dem från `location`.
- Se till att findingen har ett stabilt `fingerprint` byggt av agent/kategori, primär fil och normaliserad problemtitel.
- Lägg till en `ignored`-rad med `"ignoredBy":"human"` i `<review-root>/_review-index/ignored-findings.jsonl`, om inte samma `pr`, `findingId`, `fingerprint` och `event` redan finns.

Format för rad i ignore-indexet:

```json
{"event":"ignored","ignoredBy":"human","pr":"<branch-slug>","findingId":3,"files":["src/foo.ts"],"fingerprint":"bug-reviewer:src/foo.ts:null-user-id","agents":["bug-reviewer"],"title":"...","problem":"...","ignoreReason":"...","ignoredAt":"2026-06-26T08:04:00Z"}
```

Om ett finding går från `ignored-by-human` till en annan status, lägg till ett `unignored`-event med samma `pr`, `findingId`, `fingerprint` och en `changedAt`-tidsstämpel. Ta inte bort gamla JSONL-rader.

För följdfrågor:

- Implementera inte findingen, även om frågan är ledande.
- Svara genom att verifiera mot koden.

Svara till sist på alla användarens frågor i en tabell. Ta med alla findings där du tror att användaren kan ha missat något.
