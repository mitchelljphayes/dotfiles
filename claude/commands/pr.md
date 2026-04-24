---
description: Create a pull request for current branch
---

Create a pull request for the current branch.

1. Check if this is a GitButler-managed repository
   - If GitButler: use `but push` then `but pr`
   - If standard git: use `gh pr create`
2. Review all commits on branch vs main/develop
3. Identify main changes and purpose
4. Generate PR description with:
   - Clear, concise title
   - Summary (2-3 bullet points)
   - Breaking changes or migration notes
   - Testing notes if relevant
5. Create the PR

For stacked PRs, note dependency order.
