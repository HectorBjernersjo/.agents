# Step 5

Finally, write the final list of points you thought were worth implementing to:

```text
docs/prs/<branch-slug>/reviews/<review-id>/architecture/report.md
```

This is the only architecture-review section the implementer will actually read, so make sure each point has a good description of the problem and a very detailed single concrete fix.

One or two lines is probably not enough. Describe exactly how you would solve it:

- What classes and functions need modifying?
- Do we need to add or remove any data models?
- What should those data models look like?
- What should move, be renamed, be split, or be deleted?

It is fine if you duplicate some of what you wrote in the other sections. The important part is to include a single concrete fix with no ambiguity.

When the report is complete, report back to the main review agent with:

- The path to `report.md`.
- A short summary of every point in the report.
