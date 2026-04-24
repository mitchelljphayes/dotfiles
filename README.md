# Dotfiles

Personal dotfiles managed with a simple bash symlink installer. Everything lives in `~/.dotfiles/` and is symlinked to its destination by `install.sh`.

**Always edit files in `~/.dotfiles/`, not the symlinked locations.**

## Quick Start

```bash
git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh              # create symlinks
./install.sh --packages   # also install Homebrew packages
```

## What's Managed

| Category | Config | Symlinked To |
|----------|--------|-------------|
| **Shell** | `shell/`, `zsh/`, `zshrc`, `zprofile` | `~/.shell`, `~/.zsh`, `~/.zshrc`, `~/.zprofile` |
| **Bash** | `bash/`, `bash_profile.sh`, `bashrc.sh` | `~/.bash`, `~/.bash_profile`, `~/.bashrc` |
| **Nushell** | `nu/` | `~/Library/Application Support/nushell/` (macOS) |
| **Neovim** | `nvim/` | `~/.config/nvim` |
| **Git** | `gitconfig.toml`, `gitignore_global.conf` | `~/.gitconfig`, `~/.gitignore_global` |
| **Terminal** | `ghostty/`, `alacritty/`, `wezterm/` | `~/.config/ghostty`, etc. |
| **Tmux** | `tmux/`, `tmux/tmux.conf` | `~/.config/tmux`, `~/.tmux.conf` |
| **Prompt** | `starship.toml` | `~/.config/starship.toml` |
| **SSH** | `ssh/config`, `ssh/config.darwin` | `~/.ssh/config`, `~/.ssh/config.local` |
| **GPG** | `gpg.conf` | `~/.gnupg/gpg.conf` |
| **Zed** | `zed/settings.json`, `zed/keymap.json` | `~/.config/zed/` |
| **AI Agents** | `claude/`, `agents/`, `opencode/` | `~/.claude/`, `~/.agents/`, `~/.config/opencode/` |
| **1Password** | `1Password/` | `~/.config/1Password` |
| **Linting** | `ruff.toml` | `~/.config/ruff/ruff.toml` |
| **Packages** | `Brewfile` | `~/.Brewfile` |

Shell configs are split by purpose: `aliases.sh`, `functions.sh`, `environment.sh`, `path.sh`, `secrets.sh`.

## Adding a New Config

1. Create the file/directory in `~/.dotfiles/`
2. Add a `link` entry to `install.sh`
3. Run `./install.sh`

## Secrets

All secrets come from 1Password CLI via `shell/secrets.sh`:
- Fetched once per macOS session, cached via `launchctl setenv`
- Never stored in plaintext or committed to git
- Add new secrets to the `SECRETS` array in `secrets.sh`

## Agent Skills

Global skills for AI agents (Claude Code, OpenCode) live in `agents/skills/`:
```
~/.dotfiles/agents/skills/      ← In git, version controlled
~/.agents → ~/.dotfiles/agents/ ← npx skills writes here
~/.claude/skills → ~/.agents/skills/
```

Install a skill:
```bash
npx skills add owner/repo@skill-name -g -y
```

## Applying Changes

| What | How |
|------|-----|
| Shell | New sessions pick up changes automatically, or `source ~/.zshrc` |
| Neovim | Restart or `:source %` on changed files |
| Tmux | `tmux source-file ~/.tmux.conf` or restart |
| Terminal emulators | Restart the app |
| Git | Immediate for new commands |
| Environment variables | Log out and back in |

## Requirements

- macOS or Linux
- [Homebrew](https://brew.sh/) (macOS)
- Git 2.0+
- 1Password CLI (for secrets)

## License

MIT