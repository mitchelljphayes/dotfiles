path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")"
}

# Get machine name from ~/.name file or fallback to hostname
machine_name() {
    if [[ -f $HOME/.name ]]; then
        cat $HOME/.name
    else
        hostname
    fi
}

# Update tmux window name based on git repo (or directory name)
_tmux_update_window_name() {
    # Only run if inside tmux
    [[ -z "$TMUX" ]] && return

    local name
    # Try to get git repo name, fall back to directory name
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        name=$(basename "$(git rev-parse --show-toplevel)")
    else
        name=$(basename "$PWD")
    fi

    # Rename the current tmux window
    tmux rename-window "$name"
}

# Hook to update tmux window name on directory change
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _tmux_update_window_name
    # Also set name on shell startup
    _tmux_update_window_name
elif [[ -n "$BASH_VERSION" ]]; then
    # For bash, use PROMPT_COMMAND
    PROMPT_COMMAND="_tmux_update_window_name${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

update_terminfo () {
    local x ncdir terms
    ncdir="/opt/homebrew/opt/ncurses"
    terms=(alacritty-direct alacritty tmux tmux-256color)

    mkdir -p ~/.terminfo && cd ~/.terminfo

    if [ -d $ncdir ] ; then
        # sed : fix color for htop
        for x in $terms ; do
            $ncdir/bin/infocmp -x -A $ncdir/share/terminfo $x > ${x}.src &&
            sed -i '' 's|pairs#0x10000|pairs#32767|' ${x}.src &&
            /usr/bin/tic -x ${x}.src &&
            rm -f ${x}.src
        done
    else
        local url
        url="https://invisible-island.net/datafiles/current/terminfo.src.gz"
        if curl -sfLO $url ; then
            gunzip -f terminfo.src.gz &&
            sed -i '' 's|pairs#0x10000|pairs#32767|' terminfo.src &&
            /usr/bin/tic -xe ${(j:,:)terms} terminfo.src &&
            rm -f terminfo.src
        else
            echo "unable to download $url"
        fi
    fi
    cd - > /dev/null
}
