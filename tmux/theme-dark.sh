#!/usr/bin/env bash
# One Dark theme colors for tmux
# Triggered by client-dark-theme hook (mode 2031)

tmux set -g pane-border-style "fg=#5c6370"
tmux set -g pane-active-border-style "fg=#61afef"
tmux set -g message-style "bg=#3e4452,fg=#abb2bf"
tmux set -g message-command-style "bg=#3e4452,fg=#abb2bf"
tmux set -g status-style "bg=#282c34,fg=#abb2bf"
tmux set -g status-left "#[fg=#61afef] #S #[fg=#5c6370]│ "
tmux set -g status-right "#[fg=#5c6370]│ #[fg=#abb2bf]%Y-%m-%d #[fg=#5c6370]│ #[fg=#abb2bf]%H:%M "
tmux set -g window-status-format "#[fg=#5c6370] #I #[fg=#abb2bf]#W "
tmux set -g window-status-current-format "#[bg=#3e4452,fg=#61afef] #I #[fg=#abb2bf]#W "
tmux set -g window-status-separator "#[fg=#5c6370]│"
tmux setw -g window-status-activity-style "fg=#e5c07b,bg=#282c34"
tmux setw -g window-status-bell-style "fg=#e06c75,bg=#282c34"
tmux set -g display-panes-active-colour "#61afef"
tmux set -g display-panes-colour "#5c6370"
tmux setw -g clock-mode-colour "#61afef"
tmux setw -g mode-style "bg=#3e4452,fg=#abb2bf"
