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
- **YAML**: 2-space indentation
- **Config files**: Prefer TOML format, follow existing patterns in repo
- **Naming**: Prefer explicit over implicit, use descriptive variable/function names

## Repository Structure & Conventions

This is the canonical source for ALL dotfiles and tool configs on this machine.
Everything lives in `~/.dotfiles/` and is symlinked to its destination by `install.sh`.

**Always edit files in `~/.dotfiles/`, not the symlinked locations.**

Key directories:
- `shell/` — Shell configs split by function (aliases.sh, functions.sh, env.sh, etc.)
- `nvim/` — Neovim config (Lua)
- `opencode/` — OpenCode config, MCP servers, agents, commands, skills
- `Claude/` — Claude Desktop settings
- `claude/` — Claude Code settings (settings.json only)
- `agents/` — Agent skills shared by Claude Code and OpenCode
- `ghostty/`, `alacritty/`, `wezterm/` — Terminal emulators
- `tmux/` — Tmux config
- `zed/` — Zed editor settings
- `nu/` — Nushell config

## Symlink Mappings

Managed by `install.sh` (not the legacy `install.conf.yaml`). Run `./install` to apply.

| Repo Path | Symlinked To |
|-----------|--------------|
| `shell/` | `~/.shell` |
| `zsh/` | `~/.zsh` |
| `zshrc` | `~/.zshrc` |
| `bash/` | `~/.bash` |
| `nvim/` | `~/.config/nvim` |
| `opencode/` | `~/.config/opencode` |
| `Claude/` | `~/.config/Claude` |
| `ghostty/` | `~/.config/ghostty` |
| `alacritty/` | `~/.config/alacritty` |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/` | `~/.config/tmux` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `zed/keymap.json` | `~/.config/zed/keymap.json` |
| `1Password/` | `~/.config/1Password` |
| `starship.toml` | `~/.config/starship.toml` |
| `nu/` | `~/Library/Application Support/nushell` (macOS) |
| `gitconfig.toml` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `agents/` | `~/.agents` |
| `agents/skills/` | `~/.claude/skills` (via ~/.agents symlink) |

To add new configs: create the directory/file in this repo, add a `link` entry to `install.sh`, run `./install`.

## MCP Server Configuration

### Claude Code
The main `~/.claude.json` is NOT tracked — it contains API secrets for MCP servers.
Only `settings.json` (UI preferences) is symlinked. MCP servers with secrets are
configured manually with `claude mcp add`.

### OpenCode
OpenCode config lives at `~/.dotfiles/opencode/` and is symlinked to `~/.config/opencode/`.
- **`opencode.json`** — Main config including MCP server definitions
- **`agent/`** — Agent definitions (research, build, review, etc.)
- **`command/`** — Slash commands (/feature, /bug, /plan, etc.)
- **`skills/`** — OpenCode-specific skills

MCP servers in OpenCode use `{env:VAR_NAME}` syntax for secrets in headers.
Secrets are managed in `~/.dotfiles/shell/secrets.sh` and cached via launchctl.

### Secrets Management
All 1Password secrets are defined in `~/.dotfiles/shell/secrets.sh`:
- Sourced from `.zprofile` at login shell startup
- Fetched from 1Password (auth once per macOS session)
- Cached via `launchctl setenv` so all processes inherit them
- To add a new secret, add an entry to the `SECRETS` array in `secrets.sh`

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
