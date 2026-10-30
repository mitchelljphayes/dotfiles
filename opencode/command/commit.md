---
description: Review and commit the intended changes
agent: builder
---

Review and commit the intended changes directly: $ARGUMENTS

Invoking `/commit` authorizes the commit, not a push or PR. Do not pause just to
approve the commit message; ask only when the intended scope or safety is unclear.

1. Inspect `git status`, staged and unstaged diffs, and recent commit history.
2. Determine scope from the request and current task. Without task context, prefer
   staged changes; if neither establishes clear intent, ask rather than guess.
   Preserve unrelated changes and staging; never include them implicitly.
3. Check for secrets and review relevant verification results. Run missing checks
   where practical and report blockers rather than claiming unverified success.
4. Update `CHANGELOG.md` if present, keeping the entry scoped to this commit.
5. Stage only intended changes, inspect the complete staged diff, and check for
   whitespace errors. If unrelated staged changes prevent a safe scoped commit,
   ask how to handle them rather than committing or unstaging them silently.
6. Commit with a concise message matching the repository's conventions. Keep hooks
   enabled; fix hook failures and retry without amending or bypassing checks.
7. Report the commit SHA, subject, checks, and remaining working-tree changes.

Do not push, create a PR, amend, or change Git configuration as part of this command.
