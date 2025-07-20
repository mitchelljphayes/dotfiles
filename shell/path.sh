#!/bin/bash
# Unified PATH management for all shells

# Ensure functions are available
if ! type path_prepend &> /dev/null; then
    source ~/.shell/functions.sh
fi

# Core development paths
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.opencode/bin"
path_prepend "$HOME/.claude/local"

# Language-specific paths
path_append "$HOME/.npm-global/bin"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Database tools
path_append "/opt/homebrew/opt/postgresql@16/bin"

# Python tools
path_append "$HOME/.local/bin"  # For dbt and other pip-installed tools

# Export final PATH
export PATH
