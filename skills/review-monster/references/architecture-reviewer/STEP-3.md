# Steg 3

För varje problem du identifierat och bedömt som värt att fixa, starta en subagent.
Starta aldrig fler än 5 subagenter för det här.

Ge varje subagent:

- En detaljerad beskrivning av problemet.
- Sökvägen till PR-artefaktroten: `docs/prs/<branch-slug>/reviews/<review-id>/architecture/`.
- Arkitektur-stegmappen: `<architecture-steps-dir>`.
- Sökvägen till dess instruktioner: `<architecture-steps-dir>/subagent-prompts/SUGGEST_SOLUTIONS.md`.

Starta alla subagenter parallellt.

När alla är klara, fortsätt med:

```text
<architecture-steps-dir>/STEP-4.md
```
