When the user responds to review findings, handle fixes first and then update `docs/prs/<branch-slug>/review-data.js`.

The user may respond to each finding with one of:

- fix
- ignore
- follow-up question

For fixes:

- Implement them one at a time.
- Set the finding to `status: "implemented"`.

For ignores:

- Set the finding to `status: "ignored-by-human"`.
- Add a clear `ignoreReason`.
- Ensure the finding has `files` with repo-relative file paths without line numbers. If missing, derive them from `location`.
- Ensure the finding has a stable `fingerprint` built from agent/category, primary file, and normalized issue title.
- Append an `ignored` row with `"ignoredBy":"human"` to `docs/prs/_review-index/ignored-findings.jsonl`, unless the same `pr`, `findingId`, `fingerprint`, and `event` already exists.

Ignored index row format:

```json
{"event":"ignored","ignoredBy":"human","pr":"<branch-slug>","findingId":3,"files":["src/foo.ts"],"fingerprint":"bug-reviewer:src/foo.ts:null-user-id","agents":["bug-reviewer"],"title":"...","problem":"...","ignoreReason":"...","ignoredAt":"2026-06-26T08:04:00Z"}
```

If a finding changes from `ignored-by-human` to another status, append an `unignored` event with the same `pr`, `findingId`, `fingerprint`, and a `changedAt` timestamp. Do not remove old JSONL rows.

For follow-up questions:

- Do not implement the finding, even if the question is leading.
- Answer by verifying against the code.

At the end, answer every user question in a table. Include any finding where you think the user may have missed something.
