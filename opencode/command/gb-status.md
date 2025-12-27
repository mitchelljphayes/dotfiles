---
description: Show GitButler virtual branch status
agent: build
---

Show the current GitButler workspace status with virtual branches:

1. First check if this is a GitButler-managed repository by looking for `.git/gitbutler` directory
2. If GitButler is not initialized, inform the user and suggest running `but init`
3. Run `but status -f` to show:
   - Unassigned changes (files not yet assigned to any branch)
   - All virtual branches with their commits and assigned files
   - The common base and target branch
4. Provide a brief summary of:
   - How many virtual branches are active
   - Whether there are stacked vs parallel branches
   - Files that need to be assigned or committed

If the `but` CLI is not installed, suggest installing it via `brew install gitbutler` or through the GitButler desktop app settings.
