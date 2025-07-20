# Agent Instructions for Dotfiles Repository

## Build/Test/Lint Commands
- **Install dotfiles**: `./install` (runs dotbot with install.conf.yaml)
- **Python linting**: `ruff check .` (configured in ruff.toml)
- **Python formatting**: `ruff format .` or `black .` (line-length: 88/100)
- **SQL linting**: `sqlfluff lint` (postgres dialect, configured in .sqlfluff)
- **Single test**: No unified test framework - this is a dotfiles repo with submodules

## Code Style Guidelines
- **Python**: Follow ruff/black formatting (line-length 88), use type hints, descriptive names
- **Imports**: Standard library first, third-party, then local imports (ruff handles sorting)
- **Shell scripts**: Use `#!/usr/bin/env bash`, `set -e` for error handling
- **YAML**: 2-space indentation, consistent with install.conf.yaml structure
- **Config files**: Follow existing patterns (TOML for most configs)

## Repository Structure
- Dotbot-managed dotfiles with submodules for plugins (zsh, vim)
- Configuration files use TOML format where possible
- Shell configs split by function (aliases.sh, functions.sh, etc.)
- Neovim config in Lua, other editors have separate directories

## Error Handling
- Shell scripts should use `set -e` and proper error checking
- Python code should use explicit exception handling
- Configuration changes should be tested with `./install` before committing