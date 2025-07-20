# Personal Neovim Configuration

### Introduction

This is my personal Neovim configuration, built for modern development workflows with AI assistance, data science capabilities, and efficient editing.

**Key Features:**
* **AI-Powered Development** - GitHub Copilot integration
* **Data Science Ready** - Jupyter notebook support with Molten.nvim
* **Modern LSP Setup** - Full language server protocol support
* **Efficient Navigation** - Oil.nvim for file management, Telescope for fuzzy finding
* **Git Integration** - Built-in git signs and workflow support
* **Modular Architecture** - Clean plugin organization in `lua/plugins/`

This configuration targets the latest stable and nightly versions of Neovim.

### Installation

**Prerequisites:**
- Neovim 0.9+ (latest stable recommended)
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation) - Required for Telescope
- Node.js - For LSP servers
- Python 3.8+ - For Jupyter/Molten support
- A Nerd Font - For proper icon display

**Setup:**
1. Backup your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim and let lazy.nvim install plugins:
   ```bash
   nvim
   ```

4. Restart Neovim once installation completes.

### Configuration Structure

```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── options.lua       # Neovim options and settings
│   ├── keymaps.lua       # Key mappings
│   └── plugins/          # Plugin configurations
│       ├── init.lua      # Core plugins (lazy.nvim setup)
│       ├── lsp.lua       # Language server configuration
│       ├── telescope.lua # Fuzzy finder
│       ├── molten.lua    # Jupyter notebooks
│       ├── oil.lua       # File manager
│       └── ...           # Other plugin configs
```

### Key Features & Plugins

#### AI Development
- **GitHub Copilot** - AI code completion

#### Data Science
- **Molten.nvim** - Jupyter notebook support within Neovim
- **Render-markdown.nvim** - Beautiful markdown rendering

#### Development Tools
- **LSP** - Full language server support with auto-completion
- **Treesitter** - Advanced syntax highlighting and code understanding
- **Telescope** - Fuzzy finder for files, buffers, and more
- **Oil.nvim** - Modern file explorer
- **Gitsigns** - Git integration and diff viewing

#### UI & Navigation
- **Lualine** - Status line
- **Which-key** - Key binding hints
- **Autopairs** - Automatic bracket/quote pairing
- **Comment.nvim** - Easy commenting

### Key Mappings

**Leader Key:** `<Space>`

#### Essential Mappings
- `<leader>-` or `-` - Open Oil file manager
- `<leader>/` - Toggle line comment
- `<C-h/j/k/l>` - Navigate windows
- `<S-h/l>` - Navigate buffers
- `jk` (insert mode) - Exit to normal mode

#### AI & Development
- LSP keybindings are configured per-buffer when LSP attaches

### Customization

#### Adding New Plugins
Create a new file in `lua/plugins/` directory:

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- your configuration
    })
  end,
}
```

#### Modifying Settings
- **Editor options:** Edit `lua/options.lua`
- **Key mappings:** Edit `lua/keymaps.lua`
- **Plugin configs:** Edit respective files in `lua/plugins/`

### AI Setup

To use the AI features, you'll need:
1. **Claude API key** - Set `ANTHROPIC_API_KEY` environment variable
2. **GitHub Copilot** - Run `:Copilot auth` to authenticate

### Data Science Setup

For Jupyter notebook support:
1. Install Python dependencies:
   ```bash
   pip install pynvim jupyter
   ```
2. Install Jupyter kernel:
   ```bash
   python -m ipykernel install --user
   ```

### Troubleshooting

#### Common Issues
- **Plugins not loading:** Run `:Lazy sync` to update plugins
- **LSP not working:** Check `:LspInfo` for server status
- **Telescope errors:** Ensure ripgrep is installed
- **AI not responding:** Verify API keys are set correctly

#### Reset Configuration
```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
```

### Requirements Summary

- **Neovim 0.9+**
- **ripgrep** - File searching
- **Node.js** - LSP servers
- **Python 3.8+** - Jupyter support
- **Git** - Version control
- **Nerd Font** - Icons (optional but recommended)
=======

