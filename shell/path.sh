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

# pnpm (defined in environment.sh, add to PATH if not already present)
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Database tools
path_append "/opt/homebrew/opt/postgresql@17/bin"

# Java tools
path_append "/opt/homebrew/opt/openjdk/bin"

# Python tools (dbt and other pip-installed tools)
# .local/bin already prepended above

# TeX Live tools
path_append "/usr/local/texlive/2025/bin/universal-darwin"

# Export final PATH
export PATH
