if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Source shared shell helpers so path_prepend/path_append/path_dedup are
# available in every login shell (including non-interactive `zsh -l -c`).
# environment.sh defines PNPM_HOME (used by path.sh); functions.sh defines
# the path_* helpers. path.sh assembles the full user PATH with dedup.
# Without these here, login-non-interactive shells would only see the
# PATH that brew shellenv / macOS path_helper left behind.
source ~/.shell/environment.sh
source ~/.shell/functions.sh
source ~/.shell/path.sh

# Added by OrbStack: command-line tools and integration
# This is the single canonical source for OrbStack init (also previously
# appeared in zsh/plugins_before.zsh; that duplicate was removed to avoid
# appending ~/.orbstack/bin twice per login shell).
if [[ -f ~/.orbstack/shell/init.zsh ]]; then
    source ~/.orbstack/shell/init.zsh
fi

# Added by Obsidian — only append if the app is installed.
if [[ -d /Applications/Obsidian.app/Contents/MacOS ]]; then
    path_append "/Applications/Obsidian.app/Contents/MacOS"
fi

# Final dedup: brew shellenv internally re-runs macOS path_helper, which can
# reorder PATH and re-introduce duplicates inherited from the parent. Collapse
# everything one more time so login shells emit a clean, ordered PATH.
path_dedup
export PATH

# NOTE: ~/.shell_local_after is an untracked user-local file (sourced from
# zshrc after this). If it contains stale entries like
#   export PATH=/opt/homebrew/opt/postgresql@16/bin:$PATH
# update them to postgresql@17 (or remove them — pg18 is already available
# via /opt/homebrew/bin). This tracked file cannot fix the untracked one.