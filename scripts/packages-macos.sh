#!/usr/bin/env bash
#
# macOS package installer
# Runs Brewfile and sets up brew autoupdate
#
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# ─── Homebrew ─────────────────────────────────────────────────────────────────

install_homebrew() {
    if command -v brew &>/dev/null; then
        success "Homebrew already installed"
        return
    fi
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
}

run_brewfile() {
    info "Installing Brewfile packages (this may take a while)..."
    brew bundle --file="$DOTFILES/Brewfile" --no-lock
    success "Brewfile packages installed"
}

# ─── Brew Autoupdate ──────────────────────────────────────────────────────────

setup_brew_autoupdate() {
    # brew autoupdate runs brew update + upgrade on a schedule via launchd
    if brew autoupdate status 2>/dev/null | grep -q "installed"; then
        success "brew autoupdate already configured"
        return
    fi

    info "Setting up brew autoupdate (every 12 hours)..."
    brew tap homebrew/autoupdate 2>/dev/null || true
    # 43200 seconds = 12 hours
    # --upgrade: also upgrade outdated packages
    # --cleanup: remove old versions after upgrade
    brew autoupdate start 43200 --upgrade --cleanup
    success "brew autoupdate configured (runs every 12h)"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
    echo ""
    info "macOS package installer"
    info "======================="
    echo ""

    install_homebrew
    run_brewfile

    echo ""
    setup_brew_autoupdate

    echo ""
    success "macOS package installation complete!"
}

main "$@"
