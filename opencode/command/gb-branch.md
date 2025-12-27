---
description: Create a new GitButler virtual branch
agent: build
---

Create a new GitButler virtual branch (parallel or stacked):

Arguments: $ARGUMENTS (branch name, optionally with stack anchor)

1. Run `but status` to see existing branches and workspace state

2. Parse the arguments:
   - Simple: `<branch-name>` - creates a parallel branch
   - Stacked: `<branch-name> --on <anchor-branch>` - creates a stacked branch on top of anchor

3. If creating a parallel branch:
   - Run `but branch new <branch-name>`
   - This creates an independent branch that can be worked on alongside others

4. If creating a stacked branch:
   - Run `but branch new -a <anchor-branch> <branch-name>`
   - This creates a branch that depends on the anchor branch
   - Stacked branches must be merged in order

5. After creation, run `but status` to confirm the new branch structure

6. Explain to the user:
   - **Parallel branches**: Independent work streams, can be merged in any order
   - **Stacked branches**: Dependent changes, the base branch must merge first

Examples:
- `/gb-branch feature-auth` - Creates a parallel branch for auth feature
- `/gb-branch feature-ui --on feature-auth` - Creates a UI branch stacked on auth
