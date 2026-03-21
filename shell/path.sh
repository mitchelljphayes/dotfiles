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
path_append "$HOME/.local/share/fnm"  # fnm binary (Linux manual install)
path_append "$HOME/.npm-global/bin"
path_append "/usr/local/go/bin"       # Go toolchain (Linux manual install)

# pnpm (defined in environment.sh, add to PATH if not already present)
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# macOS-specific paths (Homebrew)
if [[ -d /opt/homebrew ]]; then
    path_append "/opt/homebrew/opt/postgresql@17/bin"
    path_append "/opt/homebrew/opt/openjdk/bin"
    path_append "/usr/local/texlive/2025/bin/universal-darwin"
fi

# Export final PATH
export PATH
