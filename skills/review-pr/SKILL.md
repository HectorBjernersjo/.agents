---
name: review-pr
description: Runs multiple reviewing agents in parallel to review the current PR and handles follow-up responses to review findings
disable-model-invocation: true
---

Use this PR review file structure:

```text
docs/prs/
├── _review-index/
│   └── ignored-findings.jsonl
└── <branch-slug>/
    ├── review.html
    ├── review-data.js
    └── reviews/
        └── review-001/
            ├── architecture/
            │   └── report.md
            ├── bug/
            │   └── report.md
            ├── code-standard/
            │   └── report.md
            ├── naming/
            │   └── report.md
            ├── simplification/
            │   └── report.md
            ├── nitpick/
            │   └── report.md
            └── slop/
                └── report.md
```

`review-data.js` is the source of truth for the current PR review. `review.html` is a static view copied from this skill's `template.html`.
`docs/prs/_review-index/ignored-findings.jsonl` is an append-only historical search index of ignored findings from all PRs.

The `review-data.js` file must be strict JSON-compatible JavaScript:

```js
window.reviewData = {
  "review": {
    "title": "PR Review",
    "branchSlug": "<branch-slug>",
    "reviewId": "<review-id>",
    "generatedAt": "<iso-8601 timestamp>",
    "sourcePath": "docs/prs/<branch-slug>/review.html",
    "baseRef": "origin/master",
    "agents": [
      "bug-reviewer",
      "code-standard-reviewer",
      "naming-reviewer",
      "simplification-reviewer",
      "nitpick-reviewer",
      "slop-reviewer"
    ]
  },
  "findings": []
};
```

Include `"architecture-reviewer"` in `review.agents` only when it was run.

Use quoted object keys, no comments, and no trailing commas inside the object so agents can parse it by stripping `window.reviewData =` and the trailing semicolon.

Historical ignored finding index rows must be one JSON object per line:

```json
{"event":"ignored","ignoredBy":"human","pr":"<branch-slug>","findingId":3,"files":["src/foo.ts"],"fingerprint":"bug-reviewer:src/foo.ts:null-user-id","agents":["bug-reviewer"],"title":"...","problem":"...","ignoreReason":"...","ignoredAt":"2026-06-26T08:04:00Z"}
```

Use `ignored-findings.jsonl` to find candidate previous ignores, then verify the new finding is the same concern before suppressing it.

## Step 1
If there are any uncommitted changes (except in package json other such files that arent at all related to this pr), tell the user to commit them before you proceed, so `git diff origin/master...` works properly.

## Step 2
Derive `<branch-slug>` from the current git branch by ignoring `users/<username>` (if that is part of the branch) and only using the rest to create a slug.
Get the current PR files with `git diff --name-only origin/master...`.

Before starting the reviewers, look for previously ignored findings that mention any of the current PR files:

- Prefer searching `docs/prs/_review-index/ignored-findings.jsonl` for exact repo-relative file paths from the current PR.
- Each matching JSONL row is a candidate previous ignore.
- Because the index is append-only, use the latest event for the same `pr`, `findingId`, and `fingerprint` to decide whether a previous ignore is still active.
- When compiling new findings later, suppress a finding only when it is clearly the same concern as a candidate previous ignore: overlapping `files`, same/similar `agents` or category, and matching `fingerprint` or substantially matching `title`/`problem`.

## Step 3
Create the next zero-padded review directory under `docs/prs/<branch-slug>/reviews/` (`review-001`, `review-002`, ...).
Each reviewing agent will write its own complete report to `<agent-name>/report.md`.

## Step 4
Decide whether this PR is large enough for `architecture-reviewer`. Default to skipping it.

Run `architecture-reviewer` only when the PR clearly has broad architectural impact, such as:

- It adds more than than 400 non-generated lines.
- It makes significant architectural changes to existing contracts or flows.
- It introduces or rewires a decently large feature flow.

Small local fixes, test-only changes, renames, formatting, copy changes, and contained refactors should not run `architecture-reviewer`.

Start "bug-reviewer", "code-standard-reviewer", "naming-reviewer", "simplification-reviewer", "nitpick-reviewer" and "slop-reviewer".
Also start "architecture-reviewer" only if the PR passed the architecture threshold above.
Pass them the resolved `<branch-slug>` and `<review-id>` so all agents write to the same review run. 
If starting `architecture-reviewer`, also pass architecture steps dir: this skill's `references/architecture-reviewer/` directory. 
Don't tell the agents anything more than that plus "go".
Spawn them all in the same call, not one at a time. And make them blocking.

## Step 5
When all of the reviewers are done, compile their findings into `docs/prs/<branch-slug>/review-data.js` and copy this skill's `template.html` to `docs/prs/<branch-slug>/review.html`.
Make sure to include all of the agents' points in the final compilation.
If multiple agents point out the exact same problem, combine it into one point in the table, you can still describe the agents solution in the description.
And pick exacly one solution which you think is best to put as the suggested fix.

If `docs/prs/<branch-slug>/review-data.js` already exists, read it before overwriting it and preserve review state from the existing `findings` array:

- Match existing findings to newly generated findings by stable identity: prefer the same `id` if the finding is clearly the same, otherwise match by title plus location/problem.
- Preserve `status` and `ignoreReason` for matched findings.
- Keep existing findings with `status: "implemented"`, `status: "ignored-by-human"`, or `status: "ignored-by-ai"` even if they are no longer present in the newest agent reports, so the PR-level review keeps its resolved/ignored history.

Each finding must include:

- `id`: index number
- `fingerprint`: stable string for the same underlying concern across review runs, built from agent/category, primary file, and normalized issue name
- `severity`: `High`, `Medium`, or `Low`
- `needsHumanCheck`: number from 1 to 10. See ### Needs human check guide for how to rank.
- `status`: `pending`, `implemented`, `ignored-by-human`, or `ignored-by-ai`. Default new findings to `pending`.
- `ignoreReason`: required when status starts with `ignored`; omit or leave empty otherwise.
- `title`: short description
- `problem`: a useful one-paragraph problem summary shown directly in the table, so the reader usually does not need to expand the row
- `description`: the full original description from the agent reports, preserving Markdown and fenced code blocks
- `fix`: the full suggested fix, preserving Markdown and fenced code blocks
- `location`: list of locations if applicable, preferably as an array of strings so each location renders on its own line
- `files`: repo-relative file paths touched by this finding, without line numbers, for example `["src/foo.ts"]`
- `agents`: all agents that found the issue

Write them in order of severity, highest first. Preserve Markdown and fenced code blocks in `description` and `fix` so the template can render them correctly.

## Step 6
As the last review step, read this skill's `COMMENT-FILTER.md` and apply it to the completed findings one at a time.

After finishing Step 6 and writing `review-data.js` and `review.html`, give the user a direct browser-openable path to `review.html`. Don't make it a link, give the exact path so they can copy.
Make the path work for the user's operating environment:

- If running in WSL and the user is likely opening the file from a Windows browser, run `wslpath -w "<absolute-path-to-review.html>"` and give the resulting `\\wsl.localhost\...` UNC path in a plain copy-pasteable text block. Do not give only a Linux `file:///home/...` URL in this case.
- Otherwise, give an appropriate `file://` URL or absolute path for the current OS.

## Responding to review findings
When the user later responds to findings from a generated review, read this skill's `RESPOND-TO-REVIEW.md` and follow it.

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
