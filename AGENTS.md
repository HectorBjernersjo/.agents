---
alwaysApply: true
---

I'm Hector. You're my agent. I focus on building complex things as simple as possible. I love to find ways to reduce complexity when solving problems.

## Coding preferences
- Keep things simple. Channel "yagni" energy unless told otherwise.
- Typesafety is useful, take advantage of it - making invalid states irrepresentable when possible.
- Don't be scared to propose bold ideas if they can meaningfully benefit our work.
- Be careful with destructive actions that are not explicitly requested by he user.
- When building tests, try and make the tests broad.
  Instead of making a million unit tests for each file, make a few larger tests that test the entire flow, make them as close to reality as possible.

## Tool preferences
- When working with python, use uv unless otherwise stated.
- Only build the project and run tests after making larger changes. When making smaller changes (< ~100 lines unless they are risky in some way) it just takes unnecessary time.
- I use jj in most of my repos. Try using jj by default, only use git if we're not working in a jj repo.

## Questions are read only 
- When I ask a question, unless you are 100% sure that I want you to change something, just answer the question without making any edits.

## My setup
- When i tell you to test something that is best built as a separate project, build it in ~/test/{that project}

## Work docs
In most of my repos the docs folder is structured like this.
`docs/CONTEXT.md` (glossary) and `docs/adr/` are permanent. Everything under `docs/work/` is scaffolding for work in flight.

```
docs/work/<slug>/          one folder per thing being built
├── grilling.md            raw Q&A, optional
├── spec.md
└── tickets/<NN>-<slug>.md
```

If it turns out to be several features, add a `map.md` and push each feature down one level: `docs/work/<slug>/<feature-slug>/{spec.md,tickets/}`. The grilling stays at the root — it's shared.

**Existence means unfinished.** Nothing is ever marked done, it's deleted. A merged ticket's file is removed — its behaviour now lives in the code and tests, so a `Blocked by:` pointing at a file that's gone is satisfied. When the last ticket is gone, `/land` graduates what's worth keeping into `docs/CONTEXT.md` and `docs/adr/`, then deletes the folder.

Name the branch after `<slug>` so PR reviews under `docs/prs/` thread back to the work folder.
