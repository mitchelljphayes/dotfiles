---
description: Git operations - status, branch, commit, assign (supports GitButler)
agent: builder
---

Delegate to **git-ops agent** to handle: $ARGUMENTS

The git-ops agent will:
1. Auto-detect GitButler vs standard Git
2. Handle the requested operation

## Common Operations

- `/git status` - Show current state
- `/git commit` - Create commit(s) for current changes
- `/git branch <name>` - Create new branch
- `/git branch <name> --on <base>` - Create stacked branch (GitButler)
- `/git assign` - Assign files to branches (GitButler)
- `/git push` - Push current branch
- `/git help` - Explain available operations

If no arguments provided, show status and suggest next actions.
