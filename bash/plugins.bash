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
# Load nvm only once (guard against multiple sources)
if [ -s "$NVM_DIR/nvm.sh" ] && [ -z "$NVM_LOADED" ]; then
    . "$NVM_DIR/nvm.sh"  # Load nvm
    export NVM_LOADED=1
fi
# Load nvm bash completion
if [ -s "$NVM_DIR/bash_completion" ] && [ -z "$NVM_COMPLETION_LOADED" ]; then
    . "$NVM_DIR/bash_completion"
    export NVM_COMPLETION_LOADED=1
fi
