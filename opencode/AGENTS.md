# OpenCode-Specific Instructions

Shared coding, security, Git, and Linear rules live in `~/.dotfiles/AGENTS.md` and
are loaded through `opencode.json`'s `instructions` setting. Edit that canonical
file for shared policy; keep this file limited to OpenCode-specific guidance.
Project-specific instructions still apply within their scope.

- Use the selected primary agent's workflow. Builder is direct; Pipeline's
  checkpoints and session artifacts apply only when that workflow is selected.
- Use todos when they help track complex work, not as ceremony for simple tasks.
  Keep one item in progress and update it when the work actually completes.
- Use the shell reported by the execution tool; do not assume it matches the
  user's interactive shell. `zoxide` (`z`) is not available in OpenCode sessions.
- After changing OpenCode configuration, agents, or commands, remind the user to
  quit and restart OpenCode. Running sessions retain the loaded configuration.
