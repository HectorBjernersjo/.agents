---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable markdown issue files under docs/issues using tracer-bullet vertical slices. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
disable-model-invocation: true
---

# To Issues

Break a plan into independently-grabbable issues using vertical slices (tracer bullets).

Always write issues as local markdown. Do not use GitHub, GitLab, `.scratch/`, or `docs/agents/issue-tracker.md`; this output location is intentionally not configurable.

## Output

- Create `docs/issues/` if it does not already exist.
- Write issues to `docs/issues/<feature-slug>-<NN>-<slice-slug>.md`, numbered from `01` within the current breakdown.
- Use short kebab-case slugs derived from the source feature and each slice title.
- Put `Status: needs-triage` near the top of each file.
- If a file with the chosen name already exists, choose the nearest clear variant instead of overwriting it.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a markdown path as an argument, read that file and use it as the source material.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Write the issue files

For each approved slice, create a new markdown issue file under `docs/issues/` using the issue body template below.

Write issues in dependency order (blockers first) so you can reference earlier issue file paths in the "Blocked by" field.

<issue-template>
# <Slice Title>

Status: needs-triage

## Parent

A reference to the parent markdown file, such as a PRD in `docs/prds/`, if the source was an existing file. Otherwise omit this section.

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking issue file path (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

Do NOT close, delete, or modify any parent/source file.
