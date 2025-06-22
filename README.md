# Dotfiles

My personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Features

- 🚀 **Multiple Shells**: Zsh (default) and Nushell configurations
- 📝 **Neovim**: Custom configuration with LSP, completions, and Claude Code integration
- 🎨 **Consistent Theme**: One Dark theme across terminals and editors
- 🔐 **Security**: 1Password SSH agent integration, secure git credentials
- 🖥️ **Terminal Emulators**: Configurations for Alacritty, WezTerm, and Ghostty
- ⚡ **Performance**: Optimized shell startup with lazy loading

## Installation

```bash
git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## Requirements

- macOS (some configurations are macOS-specific)
- [Homebrew](https://brew.sh/) for package management
- Git 2.0+

### Install Homebrew packages

```bash
brew bundle
```

## Structure

```
.dotfiles/
├── shell/          # Shell configurations (aliases, functions, exports)
├── zsh/            # Zsh-specific configurations and plugins
├── nu/             # Nushell configuration
├── nvim/           # Neovim configuration
├── tmux/           # Tmux configuration
├── alacritty/      # Alacritty terminal config
├── wezterm/        # WezTerm configuration
├── ghostty/        # Ghostty terminal config
├── ssh/            # SSH configuration
└── install         # Dotbot installer script
```

## Key Features

### Shell (Zsh/Nushell)

- Smart aliases (eza for ls, bat for cat, ripgrep for grep)
- Zoxide for smart directory jumping
- Starship prompt with custom configuration
- FZF integration for fuzzy finding

### Neovim

- Native LSP configuration (no nvim-lspconfig)
- Custom Claude Code plugin for AI assistance
- Avante.nvim for additional AI features
- Auto-formatting with conform.nvim
- Git integration with fugitive and gitsigns

### Terminal Emulators

All terminals configured with:
- One Dark color scheme
- JetBrainsMono Nerd Font
- No title bars for minimal UI

### Security

- Git credentials stored in macOS Keychain
- SSH keys managed by 1Password
- Secure SSH defaults with key hashing

## Customization

### Adding New Dotfiles

1. Add your configuration file to the repository
2. Update `install.conf.yaml` to create the symlink
3. Run `./install` to apply changes

### Shell Selection

- Default shell is Zsh
- To use Nushell: `chsh -s $(which nu)`

### Theme Changes

The One Dark theme is used consistently. To change:
1. Update color values in terminal configs
2. Change Neovim colorscheme in `nvim/lua/plugins/colorscheme.lua`
3. Update shell/tmux themes accordingly

## Tips

- Use `<leader>cc` in Neovim to open Claude Code
- Run `./install` after any configuration changes
- Check individual tool READMEs for specific features

## Troubleshooting

### Permission Issues
```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.gnupg/*
```

### Symlink Conflicts
The installer uses `force: true` for most links. Backup important configs before installing.

### Missing Commands
Ensure Homebrew packages are installed:
```bash
brew bundle check
brew bundle install
```

## Credits

Initial shell configuration inspired by [anishathalye/dotfiles](https://github.com/anishathalye/dotfiles).

## License

MIT - Feel free to use and modify these configurations
