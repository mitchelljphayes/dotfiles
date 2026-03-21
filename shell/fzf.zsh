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
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  else
    # Older fzf (< 0.48) — look for distro-provided shell integration
    local fzf_share="${${$(command -v fzf):h:h}}/share/fzf"
    [[ $- == *i* ]] && source "${fzf_share}/completion.zsh" 2>/dev/null
    source "${fzf_share}/key-bindings.zsh" 2>/dev/null
    # Fallback: Debian/Ubuntu puts them in /usr/share/doc/fzf/examples
    [[ $- == *i* ]] && source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
    source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
  fi
fi
