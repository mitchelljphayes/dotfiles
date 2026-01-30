---
description: Create a PR for current branch
agent: builder
---

Create a pull request for the current branch.

**Delegate to git-ops agent** to:

1. Detect if GitButler-managed repository
2. Review all commits on branch vs main
3. Identify main changes and purpose
4. Generate PR description with:
   - Clear, concise title
   - Summary (2-3 bullet points)
   - Breaking changes or migration notes
   - Testing notes if relevant
5. Create PR via `gh pr create` or `but push`

For stacked PRs, note dependency order.
