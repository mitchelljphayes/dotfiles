#!/usr/bin/env bash
# PreToolUse(Bash) hook: refuse `git push` while the current branch still carries
# the auto-generated worktree name (claude/<slug>-<6 hex>).
#
# Exit 0 allows the command. Exit 2 blocks it and feeds stderr back to Claude.

set -uo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // ""')

case "$cmd" in
    *"git push"*) ;;
    *) exit 0 ;;
esac

cwd=$(printf '%s' "$payload" | jq -r '.cwd // ""')
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
    cd "$cwd" || exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0

if [[ "$branch" =~ ^claude/.*-[0-9a-f]{6}$ ]]; then
    cat >&2 <<EOF
Blocked: "$branch" is an auto-generated worktree branch name.

Rename the branch before pushing, per the Git Branch Naming rules in CLAUDE.md:

    git branch -m <issue-id>-<short-description>
    git push -u origin <issue-id>-<short-description>

Use the Linear issue ID when there is one (e.g. data-2304-trunk-based-deploy),
otherwise <type>-<short-description> where type is fix, feat, chore, or refactor.
Rename before the first push, never after: renaming a pushed branch means
deleting the remote branch and breaks any open PR.
EOF
    exit 2
fi

exit 0
