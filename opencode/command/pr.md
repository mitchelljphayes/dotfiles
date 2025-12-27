---
description: Create a PR summary for current branch
agent: build
---

Analyze the current branch and prepare a pull request:

1. First, detect if this is a GitButler-managed repository:
   - Check for `.git/gitbutler` directory or run `but status`
   - If GitButler is active, adapt the workflow for virtual branches

2. For GitButler repositories:
   - Run `but status` to identify the active virtual branches
   - For the target branch, review all commits using `git log`
   - Note if this is part of a stack (dependent branches that need to merge in order)
   - When pushing, GitButler will create stacked PRs automatically

3. For standard Git repositories:
   - Run `git log main..HEAD --oneline` to see all commits on this branch
   - Run `git diff main...HEAD --stat` to see changed files

4. Identify the main changes and their purpose

5. Generate a PR description with:
   - A clear, concise title
   - Summary section with 2-3 bullet points explaining the changes
   - Any breaking changes or migration notes if applicable
   - Testing notes if relevant
   - For stacked PRs: Note the dependency order

6. Format the output so it can be easily copied into a PR form, or offer to create the PR directly:
   - Standard Git: `gh pr create`
   - GitButler: `but push` (pushes and creates PRs for virtual branches)
