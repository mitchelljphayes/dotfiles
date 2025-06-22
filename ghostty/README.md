# Ghostty Configuration

This is my Ghostty terminal configuration with a clean, minimal setup.

## Features

- **No Title Bar**: Clean borderless window with `window-decoration = false`
- **Hidden macOS Title Bar**: Additional macOS-specific setting for truly minimal look
- **One Dark Theme**: Consistent with Neovim colorscheme
- **JetBrainsMono Nerd Font**: With ligatures enabled
- **Smart Keybindings**: Splits, tabs, and navigation
- **Performance Optimized**: VSR enabled, proper cell sizing
- **Shell Integration**: Auto-detect with cursor, sudo, and title features

## Key Bindings

### Window Management
- `Cmd+Shift+Enter` - New window
- `Cmd+W` - Close current surface (tab/split/window)
- `Cmd+T` - New tab
- `Cmd+Shift+T` - New tab in current directory

### Splits
- `Cmd+D` - Split right
- `Cmd+Shift+D` - Split down
- `Cmd+Arrow` - Navigate between splits
- `Cmd+Shift+Arrow` - Resize splits (by 10 units)

### Other
- `Cmd+K` - Clear screen
- `Cmd+Shift+C` - Copy to clipboard
- `Cmd+Shift+V` - Paste from clipboard

## Installation

The configuration is automatically symlinked by dotbot to `~/.config/ghostty/config`.

To apply changes, either:
1. Restart Ghostty
2. Open command palette and reload config

## Customization

The main areas you might want to customize:

1. **Font**: Change `font-family` and `font-size`
2. **Padding**: Adjust `window-padding-x/y` for more/less space
3. **Colors**: The color scheme section uses Catppuccin Mocha
4. **Keybindings**: Add or modify in the keybind section