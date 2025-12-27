# Agent Instructions for Dotfiles Repository

## Build/Test/Lint Commands
- **Install dotfiles**: `./install` (runs dotbot with install.conf.yaml)
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