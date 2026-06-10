# Issue tracker: Local Markdown

Issues and PRDs for this repo live as markdown files in `docs/`.

## Conventions

- PRDs are written to `docs/prds/<feature-slug>.md`
- Implementation issues are written to `docs/issues/<feature-slug>-<NN>-<slice-slug>.md`, numbered from `01` within each breakdown
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new markdown file under `docs/issues/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path directly.
