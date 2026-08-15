---
description: Create a PR for current branch
agent: builder
---

Create a pull request for the current branch.

**Delegate to git-ops agent** to:

1. Review all commits on branch vs main
2. Identify main changes and purpose
3. Generate PR description with:
   - Clear, concise title
   - Summary (2-3 bullet points)
   - Breaking changes or migration notes
   - Testing notes if relevant
4. Create PR via `gh pr create`