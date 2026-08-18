# External plugins (initialized before)

# zsh-completions
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . /opt/homebrew/opt/asdf/libexec/asdf.sh

# OrbStack init is sourced once from zprofile (login-once). Interactive
# non-login children inherit ~/.orbstack/bin via the parent PATH, and
# shell/path.sh's path_dedup cleans any inherited duplicates.

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi




