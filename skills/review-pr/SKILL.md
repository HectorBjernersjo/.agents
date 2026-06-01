---
name: review-pr
description: Runs multiple reviewing agents in parallel to review the current PR
disable-model-invocation: true
---

Use this PR review file structure:

```text
docs/prs/<branch-slug>/
├── REVIEW_CONTEXT.md
└── reviews/
    └── review-001/
        ├── review.md
        └── agents/
            ├── bug-reviewer.md
            ├── architecture-reviewer.md
            └── nitpick-reviewer.md
```

Derive `<branch-slug>` from the current git branch by replacing `/` with `-` and replacing any character outside `[A-Za-z0-9._-]` with `-`.

For each run, create the next zero-padded review directory under `docs/prs/<branch-slug>/reviews/` (`review-001`, `review-002`, ...). Store the final verified review in `review.md`. If you capture raw sub-agent output, store one file per reviewer under `agents/`.

Start by running git status. If there are any uncommitted changes (except for files under `docs/prs/<branch-slug>/`), tell the user to commit them before you proceed, so `git diff origin/master...` works properly.

If there are no uncommitted changes, start by running all of your reviewing agents in parallel, you don't need to check the changes yourself yet.
When they are done, summarize ALL of their results in a table with the following columns and show it to the user:
Severity, Issue, Location (if applicable), Details, Agent (all agents that found it, can be multiple agents)
Include every issue they found, no matter how small.

Then after you've done that, go through the table and verify that each one is an actual problem.
Then create a new table excluding the ones which were hallucinations/weren't actually problems and those that were too stupid.
When going through the comments, look in `docs/prs/<branch-slug>/REVIEW_CONTEXT.md` (if it exists) to not make the same misstakes as the previous reviewer.
Note that nitpicks are good even if they are small or just point out a minor improvement. 
Also note that the user will only look at this final table so make sure it contains all the information they need. In this final table also include a number column (1 to however many rows there are).

Write the final verified table to `docs/prs/<branch-slug>/reviews/<review-id>/review.md` before finishing. Do not write filtered-out hallucinations or obviously bad comments to `REVIEW_CONTEXT.md`; that file is only for shared PR-level context future reviews should know.

Only when you are completly done and have compiled the final table, run the "remove-shitty-review-comments" skill.
