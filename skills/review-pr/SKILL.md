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
        ├── architecture/
        │   └── report.md
        ├── bug/
        │   └── report.md
        ├── code-standard/
        │   └── report.md
        ├── simplification/
        │   └── report.md
        └── nitpick/
            └── report.md
```

## Step 1
If there are any uncommitted changes (except in package json and such files that don't matter to a review), tell the user to commit them before you proceed, so `git diff origin/master...` works properly.

## Step 2
Create the next zero-padded review directory under `docs/prs/<branch-slug>/reviews/` (`review-001`, `review-002`, ...).
Each reviewing agent will write its own complete report to `<agent-name>/report.md`.
Derive `<branch-slug>` from the current git branch by ignoring `users/<username>` (if that is part of the branch) and only using the rest to create a slug.

## Step 3
Start the five reviewing agents "architecture-reviewer", "bug-reviewer", "code-standard-reviewer", "simplification-reviewer" and "nitpick-reviewer".
Pass them the resolved `<branch-slug>` and `<review-id>` so all agents write to the same review run. 
For `architecture-reviewer`, also pass architecture steps dir: this skill's `references/architecture-reviewer/` directory. 
Don't tell the agents anything more than that plus "go".
Spawn them as blocking.

## Step 4
When all of their reviwers are done, compile all of their findings into a document `docs/prs/<branch-slug>/reviews/<review-id>/review.md`.
Before writing that file though, read `docs/prs/<branch-slug>/REVIEW_CONTEXT.md` (if it exists). It includes some misstakes and false positives previous reviewers did.
Filter out any of the subagents comments that REVIEW_CONTEXT.md says to ignore.
Make sure to include all of the agents points in the final compilation, if there are duplicate points, combine them into one.
Include the following info about each point:
Index (Just number them), Severity, Short description, Location (if applicable), Problem description, Suggested fix, Agent (all agents that found it, can be multiple agents)
