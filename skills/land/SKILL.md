---
name: land
description: Retire a finished piece of work — graduate what's worth keeping into the glossary and ADRs, then delete the scaffolding under docs/work/.
disable-model-invocation: true
---

Scaffolding under `docs/work/` is deleted as work lands, never marked done. This skill runs the last step: the folder is empty of tickets, so decide what survives and remove the rest.

Run it when the last ticket of a feature merges, or the last feature of an effort.

## Process

1. **Confirm it's actually done.** Every ticket file gone, and the work merged. If tickets remain, stop and say which.

2. **Read the folder** — `grilling.md`, `spec.md`, `map.md`, resolved decision tickets.

3. **Graduate what survives.** For each decision in there, ask: is it still true, and would a future agent fail to work it out from the code and tests alone?

   - New or sharpened domain terms → `docs/CONTEXT.md`
   - Decisions where the *why* isn't visible in the code, especially rejected alternatives someone would otherwise retry → an ADR in `docs/adr/`

   Use `/domain-modeling` for both formats. Be strict: most of a spec describes behaviour that the code now describes better. A decision that the code makes obvious doesn't need an ADR.

4. **Show the user** what you're about to write and what you're about to delete, and wait for a yes.

5. **Delete**, on approval:
   - the `docs/work/<slug>/` folder (or just the `<feature-slug>/` subfolder if other features in the effort are still live)
   - `docs/prs/<branch-slug>/` for the merged branches, keeping `docs/prs/_review-index/` — it's cross-PR history

Deleting is safe: the content stays in version control under the same slug if anyone ever needs it. Leaving it is not — a shipped spec still sitting in `docs/work/` reads as planned work, and the next agent will try to build it again.
