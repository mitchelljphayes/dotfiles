# External plugins (initialized before)

# zsh-completions
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . /opt/homebrew/opt/asdf/libexec/asdf.sh


source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi




