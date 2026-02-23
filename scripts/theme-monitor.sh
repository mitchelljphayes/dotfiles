#!/usr/bin/env bash
#
# Monitor macOS appearance changes and update tmux theme
# Run as a LaunchAgent for live theme switching
#

THEME_FILE="$HOME/.tmux_theme.conf"
LAST_MODE=""

update_tmux_theme() {
    local mode="$1"
    
    if [[ "$mode" == "dark" ]]; then
        cat > "$THEME_FILE" << 'EOF'
color_bg="#282c34"
color_fg="#abb2bf"
color_current="#3e4452"
color_inactive="#5c6370"
color_active="#61afef"
color_green="#98c379"
color_yellow="#e5c07b"
color_red="#e06c75"
EOF
    else
        cat > "$THEME_FILE" << 'EOF'
color_bg="#fafafa"
color_fg="#383a42"
color_current="#e5e5e6"
color_inactive="#a0a1a7"
color_active="#4078f2"
color_green="#50a14f"
color_yellow="#c18401"
color_red="#e45649"
EOF
    fi

    # Reload all tmux sessions
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
        tmux source-file ~/.tmux.conf 2>/dev/null
    fi
}

get_appearance() {
    if defaults read -g AppleInterfaceStyle &>/dev/null; then
        echo "dark"
    else
        echo "light"
    fi
}

# Main loop - check every 2 seconds
while true; do
    current_mode=$(get_appearance)
    
    if [[ "$current_mode" != "$LAST_MODE" ]]; then
        update_tmux_theme "$current_mode"
        LAST_MODE="$current_mode"
    fi
    
    sleep 2
done
