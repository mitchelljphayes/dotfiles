# Use colors in coreutils utilities output

# Claude CLI
# alias claude="$HOME/.claude/local/claude"

# grep - use rg if available, otherwise native grep with color
if command -v rg &> /dev/null; then
    alias grep='rg'
else
    alias grep='grep --color'
fi

# ls aliases - use eza if available, otherwise native ls
if [ "$(command -v eza)" ]; then
    alias ls='eza -G  --color auto --icons -a -s type'
    alias ll='eza -l --color always --icons -a -s type'
    alias la='eza -lA --color always --icons -s type'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah'
    alias la='ls -la'
fi

# cd command - use zoxide if available and not in Claude Code/OpenCode
# (Claude Code sets CLAUDECODE=1, OpenCode may set OPENCODE=1)
if [ -z "$CLAUDECODE" ] && [ -z "$OPENCODE" ]; then
    if command -v zoxide &> /dev/null; then
        alias cd='z'
        alias cdi='zi'  # interactive mode
    elif [[ -n $STY ]]; then
        # If in screen session, use screen-aware cd
        alias cd='scr_cd'
    fi
else
    # In Claude Code or OpenCode - use builtin cd
    if [[ -n $STY ]]; then
        # But if in screen, still use screen-aware cd
        alias cd='scr_cd'
    fi
fi

# bat - use for syntax-highlighted cat if available
if [ "$(command -v bat)" ]; then
    alias cat='bat -pp --theme="OneHalfDark"'
fi

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# git related aliases
alias gag='git exec ag'
alias gc='git commit -m'
alias gca='git commit -am'

# run homebrew under rosetta 2
alias ibrew='arch -x86_64 /usr/local/bin/brew'

# mount cse
alias cse='sshfs -o idmap=user -C z5384479@login9.cse.unsw.edu.au: ~/CSE'
alias xcse='umount -f ~/CSE'


# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && ./install -q
    )
}

# Use pip without requiring virtualenv
syspip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

syspip2() {
    PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
}

syspip3() {
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

#python only calls python3
alias python='python3'
alias pip='pip3'

# uv aliases
alias py='uv run python'
alias uvr='uv run'

# cd to git root directory
alias cdgr='cd "$(git root)"'

# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}

# cd replacement for screen to track cwd (like tmux)
scr_cd()
{
    builtin cd $1
    screen -X chdir "$PWD"
}

# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}

# Execute a command in a specific directory
xin() {
    (
        cd "${1}" && shift && "${@}"
    )
}

# Check if a file contains non-ascii characters
nonascii() {
    LC_ALL=C grep -n '[^[:print:][:space:]]' "${1}"
}

# Fetch pull request

fpr() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "error: fpr must be executed from within a git repository"
        return 1
    fi
    (
        cdgr
        if [ "$#" -eq 1 ]; then
            local repo="${PWD##*/}"
            local user="${1%%:*}"
            local branch="${1#*:}"
        elif [ "$#" -eq 2 ]; then
            local repo="${PWD##*/}"
            local user="${1}"
            local branch="${2}"
        elif [ "$#" -eq 3 ]; then
            local repo="${1}"
            local user="${2}"
            local branch="${3}"
        else
            echo "Usage: fpr [repo] username branch"
            return 1
        fi

        git fetch "git@github.com:${user}/${repo}" "${branch}:${user}/${branch}"
    )
}

# Serve current directory

serve() {
    ruby -run -e httpd . -p "${1:-8080}"
}

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

alias dc='docker-compose'

# DBT aliases support
alias dbtf="$HOME/.local/bin/dbt"
