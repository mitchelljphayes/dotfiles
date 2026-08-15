---
description: Git operations — status, branch, commit, push
---

Handle git operation: $ARGUMENTS

1. Handle the requested operation

## Common Operations

- `/git status` — Show current state
- `/git commit` — Create commit(s) for current changes
- `/git branch <name>` — Create new branch
- `/git push` — Push current branch

If no arguments provided, show status and suggest next actions.

## Safety Rules

- **NEVER** push directly to `main` or `develop`
- Use `git switch --no-track -c <branch-name> origin/<base>` for new branches
- Verify tracking with `git branch -vv` before pushing