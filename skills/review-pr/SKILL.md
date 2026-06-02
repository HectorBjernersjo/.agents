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
        ├── review.html
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
When all of their reviwers are done, compile all of their findings into an HTML document `docs/prs/<branch-slug>/reviews/<review-id>/review.html`.
Before writing that file though, read `docs/prs/<branch-slug>/REVIEW_CONTEXT.md` (if it exists). It includes some misstakes and false positives previous reviewers did.
Filter out any of the subagents comments that REVIEW_CONTEXT.md says to ignore.
Make sure to include all of the agents points in the final compilation, if there are duplicate points, combine them into one.

Use this skill's `template.html` as the base for `review.html`.

First copy `template.html` to `docs/prs/<branch-slug>/reviews/<review-id>/review.html`. Then edit only that copied `review.html` to populate the `review` object and `findings` array.

Each finding must include:

- `id`: index number
- `severity`: `High`, `Medium`, or `Low`
- `title`: short description
- `problem`: a useful one-paragraph problem summary shown directly in the table, so the reader usually does not need to expand the row
- `description`: the full original description from the agent reports, preserving Markdown and fenced code blocks
- `fix`: the full suggested fix, preserving Markdown and fenced code blocks
- `location`: list of locations if applicable, preferably as an array of strings so each location renders on its own line
- `agents`: all agents that found the issue

The template controls which fields are visible in the table and which fields appear when a row is expanded. Preserve Markdown and fenced code blocks in `description` and `fix` so the template can render them correctly.

After writing `review.html`, give the user a direct link to that file they can open in a browser.
Make the link work for the user's operating environment.
