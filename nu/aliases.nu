# Nushell aliases generated from shell/aliases.sh

# Core aliases
alias grep = rg
alias ls = eza -G --color auto --icons -a -s type  
alias ll = eza -l --color always --icons -a -s type
alias cp = cp -i
alias mv = mv -i
alias cat = bat -pp --theme="OneHalfDark"

# Git aliases  
alias gag = git exec ag
alias gc = git commit -m
alias gca = git commit -am

# Python aliases
alias python = python3
alias pip = pip3

# Navigation
alias cdgr = cd (git rev-parse --show-toplevel)

# Homebrew
alias ibrew = arch -x86_64 /usr/local/bin/brew

# Zoxide
alias cd = z
alias cdi = zi

# Custom functions as aliases
def mcd [dir: string] {
    mkdir $dir
    cd $dir
}

def up [n: int = 1] {
    let path = (1..$n | each { ".." } | str join "/")
    cd $path
}

def dfu [] {
    cd ~/.dotfiles
    git pull --ff-only
    ./install -q
    cd -
}