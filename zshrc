
# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi
# External plugins (initialized before)
source ~/.zsh/plugins_before.zsh

# Settings
source ~/.zsh/settings.zsh


# Environment variables
source ~/.shell/environment.sh

# PATH management
source ~/.shell/path.sh

# Aliases
source ~/.shell/aliases.sh

# Tmux functions
source ~/.shell/tmux-functions.sh

# Custom prompt
if command -v starship &> /dev/null && [ -f ~/.config/starship.toml ]; then
    eval "$(starship init zsh)"
else
    source ~/.zsh/prompt.zsh
fi

# External plugins (initialized after)
source ~/.zsh/plugins_after.zsh

# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi
# Added by dbt Fusion extension (ensure dbt binary dir on PATH)
if [[ ":$PATH:" != *":/Users/mjp/.local/bin:"* ]]; then
  export PATH=/Users/mjp/.local/bin:"$PATH"
fi
# Added by dbt Fusion extension
alias dbtf=/Users/mjp/.local/bin/dbt

# Added by Antigravity
export PATH="/Users/mjp/.antigravity/antigravity/bin:$PATH"
