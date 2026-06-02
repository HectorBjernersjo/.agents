# Step 3

For each problem you identified that you deemed worth fixing, start a subagent.

Give each subagent:

- A detailed description of the problem.
- The path to the PR artifact root: `docs/prs/<branch-slug>/reviews/<review-id>/architecture/`.
- The architecture steps dir: `<architecture-steps-dir>`.
- The path to its instructions: `<architecture-steps-dir>/subagent-prompts/SUGGEST_SOLUTIONS.md`.

Start all subagents in parallel.

When they are all done, continue with:

```text
<architecture-steps-dir>/STEP-4.md
```
