# Setup fzf
# ---------
if [[ -d /opt/homebrew/opt/fzf ]]; then
  if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
  fi

  # Auto-completion
  [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null

  # Key bindings
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" 2>/dev/null
elif command -v fzf &>/dev/null; then
  # Non-Homebrew fzf (e.g. apt install fzf)
  source <(fzf --zsh) 2>/dev/null
fi
