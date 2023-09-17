# External plugins (initialized before)

# zsh-completions
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . /opt/homebrew/opt/asdf/libexec/asdf.sh

