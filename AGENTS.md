# Agent Instructions for Dotfiles Repository

## Build/Test/Lint Commands
- **Install dotfiles**: `./install.sh` (bash script that creates symlinks)
- **Python linting**: `ruff check .` (configured in ruff.toml, target Python 3.11)
- **Python formatting**: `ruff format .` (line-length: 88, matches Black)
- **SQL linting**: `sqlfluff lint` (postgres dialect, trailing commas required)
- **Single test**: For dotbot tests: `cd dotbot && python -m pytest tests/test_<name>.py`
- **Python execution**: Use `uv run` instead of `python` or `python3`

## Code Style Guidelines
- **Python**: Follow ruff/black formatting (line-length 88), always add type hints, descriptive names
- **Imports**: Standard library first, third-party, then local imports (ruff handles sorting)
- **Shell scripts**: Use `#!/usr/bin/env bash`, `set -e` for error handling, check exit codes
- **YAML**: 2-space indentation, consistent with install.conf.yaml structure
- **Config files**: Prefer TOML format, follow existing patterns in repo
- **Naming**: Prefer explicit over implicit, use descriptive variable/function names

## Repository Structure & Conventions
- Dotbot-managed dotfiles with submodules for plugins (zsh, vim, zsh-completions)
- Shell configs split by function (aliases.sh, functions.sh, env.sh, etc.)
- Neovim config in Lua, separate directories for each editor (vim/, nvim/, ghostty/)
- Use absolute paths when reading/writing files, verify directories exist first
- Never create documentation files unless explicitly requested
- Test configuration changes with `./install` before committing

## Symlink Structure (Important!)
Config files live in this repo and are symlinked to their destinations by Dotbot.
**Always edit files in ~/.dotfiles/, not the symlinked locations.**

Key symlink mappings (see install.conf.yaml for full list):
| Repo Path | Symlinked To |
|-----------|--------------|
| `nvim/` | `~/.config/nvim` |
| `ghostty/` | `~/.config/ghostty` |
| `alacritty/` | `~/.config/alacritty` |
| `wezterm/` | `~/.config/wezterm` |
| `Claude/` | `~/.config/Claude` |
| `opencode/` | `~/.config/opencode` |
| `tmux/` | `~/.config/tmux` |
| `zed/` | `~/.config/zed` (individual files) |
| `1Password/` | `~/.config/1Password` |
| `kanata/` | `~/.config/kanata` |
| `starship.toml` | `~/.config/starship.toml` |
| `nu/` | `~/Library/Application Support/nushell` |
| `shell/` | `~/.shell` |
| `zsh/` | `~/.zsh` |
| `claude/` | `~/.claude` (settings.json only) |
| `agents/` | `~/.agents` (skills storage for npx skills CLI) |
| `agents/skills/` | `~/.claude/skills` (via ~/.agents symlink) |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` |

To add new configs: create the directory/file in this repo, add symlink entry to `install.sh` (not the legacy YAML), run `./install`.

**Note on Claude/MCP configs:** The main `~/.claude.json` file is NOT tracked because it contains API secrets for MCP servers. Only `settings.json` (UI preferences) is symlinked. MCP servers with secrets must be configured manually with `claude mcp add`.

## Agent Skills

Global skills for Claude Code, OpenCode, and other skills-compatible agents are stored in `~/.dotfiles/agents/skills/` and made available via symlinks:

```
~/.dotfiles/agents/           ← In git, version controlled
├── .skill-lock.json          ← Tracks installed skills
└── skills/
    ├── create-skill/         ← Custom skills
    └── installed-skill/      ← Skills from npx skills CLI

~/.agents → ~/.dotfiles/agents/       ← npx skills writes here
~/.claude/skills → ~/.agents/skills/  ← Claude Code reads from here
```

### Managing Skills

```bash
# Install a skill (lands in dotfiles via symlink)
npx skills add owner/repo@skill-name -g -y

# Update all skills
npx skills update

# Create a custom skill
mkdir -p ~/.dotfiles/agents/skills/my-skill
# Then create SKILL.md following the spec
```

To create a new global skill, use the `create-skill` skill or manually create a directory in `~/.dotfiles/agents/skills/` following the Agent Skills specification (https://agentskills.io).