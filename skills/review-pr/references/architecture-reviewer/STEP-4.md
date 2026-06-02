# Step 4

Now that the agents have reported back, filter which solutions are actually worth implementing.

For each one, ask yourself: would the code actually become cleaner and easier to understand if we implemented this, or would it just move complexity around?

In the architecture artifact root, create or update:

```text
docs/prs/<branch-slug>/reviews/<review-id>/architecture/solutions-filtered.md
```

Under `# Filtered points`, write all problems with their picked solution and a rationalization, including pros and cons on why it is or is not worth implementing.

When you are done, read:

```text
<architecture-steps-dir>/STEP-5.md
```
