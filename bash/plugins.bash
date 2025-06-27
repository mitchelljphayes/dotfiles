# dircolors
# if [[ "$(tput colors)" == "256" ]]; then
#     eval "$(dircolors ~/.shell/plugins/dircolors-solarized/dircolors.256dark)"
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Initialize zoxide if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
