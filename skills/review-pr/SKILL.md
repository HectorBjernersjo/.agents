---
name: review-pr
description: Runs multiple reviewing agents in parallel to review the current PR
disable-model-invocation: true
---

Use this PR review file structure:

```text
docs/prs/<branch-slug>/
├── review.html
└── reviews/
    └── review-001/
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
When all of the reviewers are done, compile their findings into a single PR-level HTML document `docs/prs/<branch-slug>/review.html`.
Make sure to include all of the agents' points in the final compilation. If there are duplicate points, combine them into one.

If `docs/prs/<branch-slug>/review.html` already exists, read it before overwriting it and preserve review state from the existing `findings` array:

- Match existing findings to newly generated findings by stable identity: prefer the same `id` if the finding is clearly the same, otherwise match by title plus location/problem.
- Preserve `status` and `ignoreReason` for matched findings.
- Keep existing findings with `status: "implemented"` or `status: "ignored"` even if they are no longer present in the newest agent reports, so the PR-level review keeps its resolved/ignored history.
- Do not keep old `pending` findings that no longer appear in the newest agent reports unless there is a clear reason they still apply.

Use this skill's `template.html` as the base for `review.html`.

First copy `template.html` to `docs/prs/<branch-slug>/review.html`. Then edit only that copied `review.html` to populate the `review` object and `findings` array.

Each finding must include:

- `id`: index number
- `severity`: `High`, `Medium`, or `Low`
- `needsHumanCheck`: number from 1 to 10. See ### Needs human check guide for how to rank.
- `status`: `pending`, `implemented`, or `ignored`. Default new findings to `pending`.
- `ignoreReason`: required when `status` is `ignored`; omit or leave empty otherwise.
- `title`: short description
- `problem`: a useful one-paragraph problem summary shown directly in the table, so the reader usually does not need to expand the row
- `description`: the full original description from the agent reports, preserving Markdown and fenced code blocks
- `fix`: the full suggested fix, preserving Markdown and fenced code blocks
- `location`: list of locations if applicable, preferably as an array of strings so each location renders on its own line
- `agents`: all agents that found the issue

Write them in order of severity, highest first. Preserve Markdown and fenced code blocks in `description` and `fix` so the template can render them correctly.

After writing `review.html`, give the user a direct browser-openable path to that file. Don't make it a link, give the exact path so they can copy.
Make the path work for the user's operating environment:

- If running in WSL and the user is likely opening the file from a Windows browser, run `wslpath -w "<absolute-path-to-review.html>"` and give the resulting `\\wsl.localhost\...` UNC path in a plain copy-pasteable text block. Do not give only a Linux `file:///home/...` URL in this case.
- Otherwise, give an appropriate `file://` URL or absolute path for the current OS.

### Needs human check guide
Low numbers mean the agent would theoretically be comfortable implementing the fix without asking the user.
High numbers mean the finding may need human judgment because the agent is less certain it is correct.
Things to consider when setting the "Needs human check" score:
- If it's pre existing the score should be higher.
- If it might be out of scope for this pr it should be higher (at least if it's a bigger change).
- If it only or mostly touches code from this pr it should be lower.
- Bigger changes should be higher and smaller changes lower.
- If you there may be a deliberate reason for the current behavior it should be higher.
- If there are many possible fixes to a problem and you're not sure this is the best one.
