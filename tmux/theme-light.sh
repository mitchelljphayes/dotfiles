#!/usr/bin/env bash
# One Light theme colors for tmux
# Triggered by client-light-theme hook (mode 2031)

tmux set -g pane-border-style "fg=#a0a1a7"
tmux set -g pane-active-border-style "fg=#4078f2"
tmux set -g message-style "bg=#e5e5e6,fg=#383a42"
tmux set -g message-command-style "bg=#e5e5e6,fg=#383a42"
tmux set -g status-style "bg=#fafafa,fg=#383a42"
tmux set -g status-left "#[fg=#4078f2] #S #[fg=#a0a1a7]│ "
tmux set -g status-right "#[fg=#a0a1a7]│ #[fg=#383a42]%Y-%m-%d #[fg=#a0a1a7]│ #[fg=#383a42]%H:%M "
tmux set -g window-status-format "#[fg=#a0a1a7] #I #[fg=#383a42]#W "
tmux set -g window-status-current-format "#[bg=#e5e5e6,fg=#4078f2] #I #[fg=#383a42]#W "
tmux set -g window-status-separator "#[fg=#a0a1a7]│"
tmux setw -g window-status-activity-style "fg=#c18401,bg=#fafafa"
tmux setw -g window-status-bell-style "fg=#e45649,bg=#fafafa"
tmux set -g display-panes-active-colour "#4078f2"
tmux set -g display-panes-colour "#a0a1a7"
tmux setw -g clock-mode-colour "#4078f2"
tmux setw -g mode-style "bg=#e5e5e6,fg=#383a42"
