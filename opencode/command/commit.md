---
description: Generate a commit for staged changes
agent: builder
---

Create a well-crafted commit for the current changes.

**Delegate to git-ops agent** to:

1. Detect if GitButler-managed repository
2. Analyze staged/unstaged changes
3. Generate conventional commit message
4. Update CHANGELOG.md if present
5. Show proposed commit for approval

Wait for my approval before committing.
