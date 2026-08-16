---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

If something you learn while building contradicts the spec, update the spec before you finish. It outlives every ticket, so a stale one misleads the next session.

Once done, use /code-review to review the work.

Commit your work to the current branch. When the ticket is merged, delete its file — that's what marks it done. If it was the last one, run /land.
