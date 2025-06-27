#!/bin/bash
# Tmux session management functions

# Quick tmux session switcher using fzf
ts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}

# Create or switch to tmux session
tm() {
  local session="$1"
  if [ -z "$session" ]; then
    # If no session name provided, use fzf to select
    ts
  else
    # Check if session exists
    if tmux has-session -t "$session" 2>/dev/null; then
      # If inside tmux, switch to the session
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session"
      else
        # If outside tmux, attach to the session
        tmux attach -t "$session"
      fi
    else
      # Create new session
      if [ -n "$TMUX" ]; then
        tmux new-session -d -s "$session"
        tmux switch-client -t "$session"
      else
        tmux new-session -s "$session"
      fi
    fi
  fi
}

# Kill tmux session with fzf
tk() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --query="$1" --select-1 --exit-0) &&
    tmux kill-session -t "$session"
}

# List all tmux sessions
tl() {
  tmux list-sessions 2>/dev/null || echo "No tmux sessions"
}

# Rename current tmux session
tr() {
  if [ -n "$TMUX" ]; then
    tmux rename-session "$1"
  else
    echo "Not in a tmux session"
  fi
}