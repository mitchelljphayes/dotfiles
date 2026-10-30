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

    git branch -m <type>/<short-description>
    git push -u origin <type>/<short-description>

Type is feat, fix, chore, refactor, or docs. When there is a Linear issue, put
its ID after the slash (e.g. feat/data-2304-trunk-based-deploy).
Run the rename as its own command: this hook reads the branch before the command
runs, so a rename and push in one command is still blocked.
Rename before the first push, never after: renaming a pushed branch means
deleting the remote branch and breaks any open PR.
EOF
    exit 2
fi

exit 0
