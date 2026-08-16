---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.
You can have a maximum of 5 questions per round. Fewer the more complex and or uncertain they are.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

If the user asks you to sync this grilling session to a file, write it to `docs/work/<slug>/grilling.md` — the spec and tickets land in the same folder, so pick the slug they'll use. If the session turns out to cover several features, the grilling stays at that root and the features become subfolders beside it. Fall back to a descriptive name when the grilling isn't tied to a feature. If the file already exists, append to it. Write it as a list of questions and answers under # Questions and Answers.
If you've also done research or in some other way aquired relevant information that isn't easily found in the repo, write a section # Research for that information as well.
The point of the file is to carry the raw data of everything we've arrived at during this session in a concise way.
