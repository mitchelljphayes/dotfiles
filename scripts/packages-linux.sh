#!/usr/bin/env bash
#
# Linux (Ubuntu/Debian) package installer
# Equivalent of Brewfile for apt-based systems
#
# Usage:
#   ./packages-linux.sh              # Install missing packages only
#   ./packages-linux.sh --upgrade    # Upgrade all packages to latest
#
set -e

UPGRADE=false
if [[ "${1:-}" == "--upgrade" || "${1:-}" == "-u" ]]; then
    UPGRADE=true
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Skip install if already present (unless --upgrade)
already_installed() {
    local cmd="$1"
    if [[ "$UPGRADE" == true ]]; then
        return 1  # always re-install in upgrade mode
    fi
    command -v "$cmd" &>/dev/null
}

need_sudo() {
    if [[ $EUID -ne 0 ]]; then
        SUDO="sudo"
    else
        SUDO=""
    fi
}

need_sudo

# ─── APT Packages ────────────────────────────────────────────────────────────

APT_PACKAGES=(
    # Terminal & Shell
    bat                     # Better cat with syntax highlighting
    eza                     # Modern ls replacement
    fd-find                 # Fast find alternative (binary: fdfind)
    ripgrep                 # Fast grep
    tmux                    # Terminal multiplexer
    tree                    # Directory tree viewer
    zsh                     # Shell

    # Development Tools
    cmake                   # Build tool
    git-lfs                 # Git large file storage
    jq                      # JSON processor
    build-essential         # gcc, make, etc.
    curl                    # HTTP client
    unzip                   # Archive tool

    # Cloud & DevOps
    kubectl                 # Kubernetes CLI (via apt repo)

    # Utilities
    htop                    # Process viewer
    gnupg                   # GPG
    wget                    # File downloader
    ffmpeg                  # Media processing

    # JS Package Managers
    # (installed via n/npm below)
)

# ─── APT Repositories ────────────────────────────────────────────────────────

setup_apt_repos() {
    info "Setting up additional apt repositories..."

    # GitHub CLI
    if ! apt-cache policy gh 2>/dev/null | grep -q github; then
        info "Adding GitHub CLI repo..."
        $SUDO mkdir -p /etc/apt/keyrings
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            | $SUDO tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
            | $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    fi

    # Kubernetes (kubectl)
    if ! apt-cache policy kubectl 2>/dev/null | grep -q pkgs.k8s.io; then
        info "Adding Kubernetes repo..."
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
            | $SUDO gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg 2>/dev/null
        echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" \
            | $SUDO tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
    fi

    # Git Delta (via GitHub releases, not apt — handled below)
    # Neovim stable PPA for latest version
    if ! apt-cache policy neovim 2>/dev/null | grep -q neovim-ppa; then
        info "Adding Neovim stable PPA..."
        $SUDO add-apt-repository -y ppa:neovim-ppa/stable
    fi
}

# ─── Install APT packages ────────────────────────────────────────────────────

install_apt_packages() {
    info "Updating apt cache..."
    $SUDO apt update -qq

    if [[ "$UPGRADE" == true ]]; then
        info "Upgrading apt packages..."
        $SUDO apt upgrade -y
    fi

    info "Installing apt packages..."
    $SUDO apt install -y "${APT_PACKAGES[@]}" gh neovim

    # fd-find installs as fdfind — symlink to fd
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        $SUDO ln -sf "$(which fdfind)" /usr/local/bin/fd
        success "Symlinked fdfind → fd"
    fi
}

# ─── Binary installers (not in apt or apt version too old) ────────────────────

install_fzf() {
    # Remove old apt version if present (too old for --zsh flag)
    if dpkg -s fzf &>/dev/null 2>&1; then
        info "Removing outdated apt fzf..."
        $SUDO apt remove -y fzf >/dev/null
    fi
    if already_installed fzf; then
        success "fzf already installed ($(fzf --version | awk '{print $1}'))"
        return
    fi
    info "Installing fzf..."
    FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
    curl -Lo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
    tar xf /tmp/fzf.tar.gz -C /tmp fzf
    $SUDO install /tmp/fzf /usr/local/bin
    rm -f /tmp/fzf /tmp/fzf.tar.gz
    success "fzf ${FZF_VERSION} installed"
}

install_zoxide() {
    if already_installed zoxide; then
        success "zoxide already installed ($(zoxide --version))"
        return
    fi
    info "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    success "zoxide installed"
}

install_starship() {
    if already_installed starship; then
        success "starship already installed ($(starship --version | head -1))"
        return
    fi
    info "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    success "starship installed"
}

install_uv() {
    if already_installed uv; then
        success "uv already installed ($(uv --version))"
        return
    fi
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    success "uv installed"
}

install_lazygit() {
    if already_installed lazygit; then
        success "lazygit already installed ($(lazygit --version | head -1))"
        return
    fi
    info "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    $SUDO install /tmp/lazygit /usr/local/bin
    rm -f /tmp/lazygit /tmp/lazygit.tar.gz
    success "lazygit ${LAZYGIT_VERSION} installed"
}

install_delta() {
    if already_installed delta; then
        success "git-delta already installed ($(delta --version))"
        return
    fi
    info "Installing git-delta..."
    local release_json
    release_json=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest")
    DELTA_VERSION=$(echo "$release_json" | jq -r '.tag_name')
    DELTA_URL=$(echo "$release_json" | jq -r '.assets[] | select(.name | test("amd64\\.deb$")) | .browser_download_url' | head -1)
    curl -Lo /tmp/git-delta.deb "$DELTA_URL"
    $SUDO dpkg -i /tmp/git-delta.deb
    rm -f /tmp/git-delta.deb
    success "git-delta ${DELTA_VERSION} installed"
}

install_bottom() {
    if already_installed btm; then
        success "bottom already installed ($(btm --version))"
        return
    fi
    info "Installing bottom (btm)..."
    local release_json
    release_json=$(curl -s "https://api.github.com/repos/ClementTsang/bottom/releases/latest")
    BTM_VERSION=$(echo "$release_json" | jq -r '.tag_name')
    # Prefer non-musl .deb, fall back to musl
    BTM_URL=$(echo "$release_json" | jq -r '[.assets[] | select(.name | test("amd64\\.deb$"))] | sort_by(.name | contains("musl")) | .[0].browser_download_url')
    curl -Lo /tmp/bottom.deb "$BTM_URL"
    $SUDO dpkg -i /tmp/bottom.deb
    rm -f /tmp/bottom.deb
    success "bottom ${BTM_VERSION} installed"
}

install_k9s() {
    if already_installed k9s; then
        success "k9s already installed ($(k9s version --short 2>/dev/null || echo 'unknown'))"
        return
    fi
    info "Installing k9s..."
    K9S_VERSION=$(curl -s "https://api.github.com/repos/derailed/k9s/releases/latest" | jq -r '.tag_name')
    curl -Lo /tmp/k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
    tar xf /tmp/k9s.tar.gz -C /tmp k9s
    $SUDO install /tmp/k9s /usr/local/bin
    rm -f /tmp/k9s /tmp/k9s.tar.gz
    success "k9s ${K9S_VERSION} installed"
}

install_doctl() {
    if already_installed doctl; then
        success "doctl already installed ($(doctl version --short 2>/dev/null || doctl version | head -1))"
        return
    fi
    info "Installing doctl..."
    DOCTL_VERSION=$(curl -s "https://api.github.com/repos/digitalocean/doctl/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
    curl -Lo /tmp/doctl.tar.gz "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz"
    tar xf /tmp/doctl.tar.gz -C /tmp doctl
    $SUDO install /tmp/doctl /usr/local/bin
    rm -f /tmp/doctl /tmp/doctl.tar.gz
    success "doctl ${DOCTL_VERSION} installed"
}

install_duckdb() {
    if already_installed duckdb; then
        success "duckdb already installed"
        return
    fi
    info "Installing duckdb..."
    DUCKDB_VERSION=$(curl -s "https://api.github.com/repos/duckdb/duckdb/releases/latest" | jq -r '.tag_name')
    curl -Lo /tmp/duckdb.zip "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip"
    unzip -o /tmp/duckdb.zip -d /tmp
    $SUDO install /tmp/duckdb /usr/local/bin
    rm -f /tmp/duckdb /tmp/duckdb.zip
    success "duckdb ${DUCKDB_VERSION} installed"
}

install_awscli() {
    if already_installed aws; then
        success "awscli already installed ($(aws --version 2>&1 | head -1))"
        return
    fi
    info "Installing AWS CLI..."
    curl -Lo /tmp/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    unzip -o /tmp/awscliv2.zip -d /tmp
    $SUDO /tmp/aws/install --update
    rm -rf /tmp/aws /tmp/awscliv2.zip
    success "awscli installed"
}

# ─── Language Runtimes ────────────────────────────────────────────────────────

install_n_and_node() {
    if already_installed n; then
        if [[ "$UPGRADE" == true ]]; then
            info "Upgrading Node to latest LTS..."
            $SUDO n lts
        else
            success "n already installed"
        fi
    else
        info "Installing n (Node version manager)..."
        curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | $SUDO bash -s lts
        success "n + Node LTS installed"
    fi

    # Install JS package managers via npm
    if command -v npm &>/dev/null; then
        for pkg in pnpm yarn; do
            if already_installed "$pkg"; then
                success "$pkg already installed"
            else
                info "Installing $pkg..."
                $SUDO npm install -g "$pkg"
                success "$pkg installed"
            fi
        done
    fi
}

install_go() {
    if already_installed go; then
        success "go already installed ($(go version | awk '{print $3}'))"
        return
    fi
    info "Installing Go..."
    GO_VERSION=$(curl -s 'https://go.dev/VERSION?m=text' | head -1)
    curl -Lo /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    $SUDO rm -rf /usr/local/go
    $SUDO tar -C /usr/local -xzf /tmp/go.tar.gz
    rm -f /tmp/go.tar.gz
    success "Go ${GO_VERSION} installed to /usr/local/go"
}

install_rust() {
    if already_installed rustup; then
        if [[ "$UPGRADE" == true ]]; then
            info "Upgrading Rust..."
            rustup update
            success "rust upgraded"
        else
            success "rust already installed ($(rustc --version 2>/dev/null || echo 'unknown'))"
        fi
        return
    fi
    info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    success "rust installed"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
    echo ""
    info "Linux package installer"
    if [[ "$UPGRADE" == true ]]; then
        info "Mode: UPGRADE (reinstalling all binary tools to latest)"
    else
        info "Mode: INSTALL (skipping already installed tools)"
    fi
    info "======================="
    echo ""

    setup_apt_repos
    install_apt_packages

    echo ""
    info "Installing tools from binary releases..."
    install_fzf
    install_zoxide
    install_starship
    install_uv
    install_lazygit
    install_delta
    install_bottom
    install_k9s
    install_doctl
    install_duckdb
    install_awscli

    echo ""
    info "Installing language runtimes..."
    install_n_and_node
    install_go
    install_rust

    echo ""
    success "Linux package installation complete!"
    echo ""
    warn "You may need to restart your shell for PATH changes to take effect."
}

main "$@"
