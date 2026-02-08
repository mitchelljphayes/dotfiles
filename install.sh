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
link_darwin() { [[ "$OS" == "Darwin" ]] && link "$1" "$2"; }
link_linux() { [[ "$OS" == "Linux" ]] && link "$1" "$2"; }

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
link alacritty      ~/.config/alacritty
link ghostty        ~/.config/ghostty
link wezterm        ~/.config/wezterm

# Tmux
link tmux           ~/.config/tmux
link tmux/tmux.conf ~/.tmux.conf

# Tools
link starship.toml  ~/.config/starship.toml
link kanata         ~/.config/kanata
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

echo ""
success "Dotfiles installation complete!"
