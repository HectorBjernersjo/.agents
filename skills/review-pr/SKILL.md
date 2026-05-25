---
name: review-pr
description: Runs multiple reviewing agents in parallel to review the current PR
disable-model-invocation: true
---

Start by running git status. If there are any uncommitted changes (except for REVIEW_CONTEXT.md), tell the user to commit them before you proceed, so `git diff origin/master...` works properly.

If there are no uncommitted changes, start by running all of your reviewing agents in parallel, you don't need to check the changes yourself yet.
When they are done, summarize ALL of their results in a table with the following columns and show it to the user:
Severity, Issue, Location (if applicable), Details, Agent (all agents that found it, can be multiple agents)
Include every issue they found, no matter how small.

Then after you've done that, go through the table and verify that each one is an actual problem.
Then create a new table excluding the ones which were hallucinations/weren't actually problems and those that were too stupid.
When going through the comments, look in REVIEW_CONTEXT.md (if it exists) to not make the same misstakes as the previous reviewer.
Note that nitpicks are good even if they are small or just point out a minor improvement. 
Also note that the user will only look at this final table so make sure it contains all the information they need. In this final table also include a number column (1 to however many rows there are).

Only when you are completly done and have compiled the final table, run the "remove-shitty-review-comments" skill.
