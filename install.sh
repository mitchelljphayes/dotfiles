#!/usr/bin/env bash
#
# Dotfiles installer - replaces Dotbot with simple bash
#
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(uname)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create symlink, backing up existing files if needed
link() {
    local src="$DOTFILES/$1"
    local dst="$2"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dst")"
    
    # Handle existing files/directories
    if [[ -L "$dst" ]]; then
        # Remove existing symlink
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        # Backup existing file/directory
        local backup="$dst.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up $dst to $backup"
        mv "$dst" "$backup"
    fi
    
    ln -s "$src" "$dst"
    success "$dst"
}

# Link only on specific OS
link_darwin() { [[ "$OS" == "Darwin" ]] && link "$1" "$2" || true; }
link_linux() { [[ "$OS" == "Linux" ]] && link "$1" "$2" || true; }

# Clean dead symlinks in a directory
clean_dead_links() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        find "$dir" -maxdepth 1 -type l ! -exec test -e {} \; -delete 2>/dev/null || true
    fi
}

echo ""
info "Installing dotfiles from $DOTFILES"
info "Detected OS: $OS"
echo ""

# Clean dead symlinks
info "Cleaning dead symlinks..."
clean_dead_links "$HOME"
clean_dead_links "$HOME/.config"

echo ""
info "Creating symlinks..."

# Shell
link shell              ~/.shell
link zsh                ~/.zsh
link zshrc              ~/.zshrc
link zprofile           ~/.zprofile
link bash               ~/.bash
link bash_profile.sh    ~/.bash_profile
link bashrc.sh          ~/.bashrc
link shell/fzf.bash     ~/.fzf.bash
link shell/fzf.zsh      ~/.fzf.zsh

# Git
link gitconfig.toml         ~/.gitconfig
link gitignore_global.conf  ~/.gitignore_global
link_darwin gitconfig_local_macos.toml ~/.gitconfig_local

# Editors
link nvim       ~/.config/nvim
link vimrc      ~/.vimrc
link zed/settings.json  ~/.config/zed/settings.json
link zed/keymap.json    ~/.config/zed/keymap.json

# Terminal emulators
link ghostty        ~/.config/ghostty
link wezterm        ~/.config/wezterm

# Tmux
link tmux           ~/.config/tmux
link tmux/tmux.conf ~/.tmux.conf

# Tools
link starship.toml  ~/.config/starship.toml
link kanata         ~/.config/kanata
link switcheroo     ~/.config/switcheroo
link opencode       ~/.config/opencode
link 1Password      ~/.config/1Password
link ssh/config     ~/.ssh/config
link_darwin ssh/config.darwin  ~/.ssh/config.local
link_linux  ssh/config.linux   ~/.ssh/config.local
link gpg.conf       ~/.gnupg/gpg.conf
link yarnrc         ~/.yarnrc
link kaggle         ~/.kaggle
link terminfo.src   ~/.terminfo.src
link CLAUDE.md              ~/.claude/CLAUDE.md
link claude/settings.json  ~/.claude/settings.json
link agents                 ~/.agents
link Claude                 ~/.config/Claude

# Claude skills - points to ~/.agents/skills (which is symlinked above)
# This allows 'npx skills' to install directly to dotfiles
if [[ -L "$HOME/.claude/skills" ]]; then
    rm "$HOME/.claude/skills"
elif [[ -e "$HOME/.claude/skills" ]]; then
    mv "$HOME/.claude/skills" "$HOME/.claude/skills.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -s "$HOME/.agents/skills" "$HOME/.claude/skills"
success "~/.claude/skills"

# Nushell (macOS only - different path on Linux)
link_darwin nu/config.nu    ~/Library/Application\ Support/nushell/config.nu
link_darwin nu/env.nu       ~/Library/Application\ Support/nushell/env.nu
link_darwin nu/aliases.nu   ~/Library/Application\ Support/nushell/aliases.nu
link_darwin nu/scripts      ~/Library/Application\ Support/nushell/scripts
link_darwin nu/vendor       ~/Library/Application\ Support/nushell/vendor

# Ordermentum project-specific OpenCode config (symlink into each git repo)
OM_DIR="$HOME/Developer/ordermentum"
if [[ -d "$OM_DIR" ]]; then
    info "Symlinking ordermentum opencode.json into project repos..."
    for repo in "$OM_DIR"/*/; do
        if [[ -d "$repo/.git" ]]; then
            link ordermentum/opencode.json "$repo/opencode.json"
        fi
    done
fi

# LaunchAgents (macOS)
link_darwin launchagents/com.mjp.theme-monitor.plist ~/Library/LaunchAgents/com.mjp.theme-monitor.plist

# Linux-specific (add as needed)
# link_linux nu/config.nu   ~/.config/nushell/config.nu

echo ""

# Git submodules (skip in Codespaces for faster startup)
if [[ -n "$CODESPACES" ]]; then
    info "Skipping submodules in Codespaces environment"
else
    info "Updating git submodules..."
    git -C "$DOTFILES" submodule sync --recursive
    git -C "$DOTFILES" submodule update --init --recursive
fi

# Package installation (OS-specific)
# Usage: ./install.sh --packages          # install missing packages
#        ./install.sh --packages --upgrade # upgrade all to latest
echo ""
INSTALL_PACKAGES=false
UPGRADE_FLAG=""
for arg in "$@"; do
    case "$arg" in
        --packages|-p) INSTALL_PACKAGES=true ;;
        --upgrade|-u)  UPGRADE_FLAG="--upgrade" ;;
    esac
done

if [[ "$INSTALL_PACKAGES" == true ]]; then
    if [[ "$OS" == "Darwin" ]]; then
        info "Running macOS package installer..."
        bash "$DOTFILES/scripts/packages-macos.sh"
    elif [[ "$OS" == "Linux" ]]; then
        info "Running Linux package installer..."
        bash "$DOTFILES/scripts/packages-linux.sh" $UPGRADE_FLAG
    fi
else
    info "Skipping package installation (run with --packages to install)"
fi

echo ""
success "Dotfiles installation complete!"
