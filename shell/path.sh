# Unified PATH management for all shells.
# Sourced by both zsh (zshrc, zprofile) and bash (bashrc.sh) — keep POSIX-sh.
# Every entry is existence-guarded so dead directories never enter PATH;
# path_dedup at the end collapses any duplicates inherited from the parent
# environment or introduced by macOS path_helper / brew shellenv.

# Ensure functions are available
if ! type path_prepend &> /dev/null; then
    source ~/.shell/functions.sh
fi

# Core development paths (prepended in priority order; first wins)
[[ -d "$HOME/.local/bin" ]]   && path_prepend "$HOME/.local/bin"
[[ -d "$HOME/.cargo/bin" ]]   && path_prepend "$HOME/.cargo/bin"
[[ -d "$HOME/.opencode/bin" ]] && path_prepend "$HOME/.opencode/bin"
[[ -d "$HOME/.claude/local" ]] && path_prepend "$HOME/.claude/local"

# Language-specific paths (appended; expected future / Linux manual installs)
[[ -d "$HOME/.npm-global/bin" ]]  && path_append "$HOME/.npm-global/bin"
[[ -d "/usr/local/go/bin" ]]      && path_append "/usr/local/go/bin"        # Go toolchain (Linux manual install)

# pnpm (PNPM_HOME defined in environment.sh; only add if the dir exists)
if [[ -n "$PNPM_HOME" && -d "$PNPM_HOME" ]]; then
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

# macOS-specific paths (Homebrew kegs; guard each keg individually)
if [[ -d /opt/homebrew ]]; then
    # rustup is keg-only; prefer its proxies while keeping Cargo-installed tools.
    [[ -d "/opt/homebrew/opt/rustup/bin" ]] && path_prepend "/opt/homebrew/opt/rustup/bin"
    [[ -d "/opt/homebrew/opt/postgresql@17/bin" ]] && path_append "/opt/homebrew/opt/postgresql@17/bin"
    [[ -d "/opt/homebrew/opt/openjdk/bin" ]]       && path_append "/opt/homebrew/opt/openjdk/bin"
    [[ -d "/usr/local/texlive/2025/bin/universal-darwin" ]] && path_append "/usr/local/texlive/2025/bin/universal-darwin"
fi

# Tool-specific paths (conditional on directory existence)
if [[ -d "$HOME/.antigravity/antigravity/bin" ]]; then
    path_prepend "$HOME/.antigravity/antigravity/bin"
fi

# Resolve tools in scripts, login shells, and editors without interactive hooks.
# Keep shims ahead of system runtimes; mise activation prefers real tool paths.
[[ -d "$HOME/.local/share/mise/shims" ]] && path_prepend "$HOME/.local/share/mise/shims"

# Collapse any duplicates (inherited from parent, path_helper reorders, or
# repeated sourcing of this file) while preserving first-occurrence order.
path_dedup

# Export final PATH
export PATH
