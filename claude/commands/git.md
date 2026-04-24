---
description: Git operations — status, branch, commit, assign (supports GitButler)
---

Handle git operation: $ARGUMENTS

1. Auto-detect GitButler vs standard Git:
   - Run `but status` — if it works, this is a GitButler repo
   - Use `but` commands for GitButler repos, `git` for standard repos
2. Handle the requested operation

## Common Operations

- `/git status` — Show current state
- `/git commit` — Create commit(s) for current changes
- `/git branch <name>` — Create new branch
- `/git branch <name> --on <base>` — Create stacked branch (GitButler)
- `/git assign` — Assign files to branches (GitButler)
- `/git push` — Push current branch

If no arguments provided, show status and suggest next actions.

## Safety Rules

- **NEVER** push directly to `main` or `develop`
- Use `git switch --no-track -c <branch-name> origin/<base>` for new branches
- Verify tracking with `git branch -vv` before pushing
