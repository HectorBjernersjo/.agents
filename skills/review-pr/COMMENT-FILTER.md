As the final review step, mark low-value findings as `ignored-by-ai` instead of leaving them pending.
Keep filtered findings in `review-data.js` with a clear `ignoreReason`.
For each finding newly marked `ignored-by-ai`, append an `ignored` row with `"ignoredBy":"ai"` to `docs/prs/_review-index/ignored-findings.jsonl`, unless the same `pr`, `findingId`, `fingerprint`, and `event` already exists.

Mark a finding as `ignored-by-ai` when it:

- Raises something already covered by review context or previous ignored findings.
- Suggests an unnecessary refactor that would make the code worse.
- Claims something is a bug when it is not actually a bug.
- Flags behavior that is clearly intentional.
- Suggests a change that goes against established codebase patterns.
- Points out pre-existing code that was not changed in this PR, unless it is important enough to include anyway.
- Duplicates another finding. Merge duplicates into the best single finding where useful.
- Points out UTF-8 BOM; tests cover this and it does not need a PR comment.
- Says something is bad when it is actually good.
- Suggests making a class sealed.
- Comments on commit messages; PRs are squashed anyway.
- Claims a null reference risk when there is no real risk.

Do not mark something `ignored-by-ai` just because it is a nitpick or only slightly useful.

Evaluate every finding by the resulting code change, not by whether the suggestion has any theoretical benefit.

Mark a finding as `ignored-by-ai` when the proposed fix does not make the codebase better overall. Consider readability, simplicity, maintainability, brittleness, duplication, and actual defect prevention together. A local benefit is not enough when the resulting code adds equal or greater cost.

Before keeping a finding, mentally apply the suggested fix and compare the before and after versions. Keep it only when the resulting code is clearly better.

If a claim can be verified by searching docs or writing/running a small test, verify it before deciding.

When code looks inconsistent with shared or standard patterns, investigate why before suggesting a change.

For refactoring, renaming, or extraction suggestions, think through the result: would the code actually be better, and is the extra abstraction worth it?

Review every finding one at a time. Verify the code carefully for each finding that needs verification.
