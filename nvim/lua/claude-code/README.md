# Claude Code for Neovim

A Neovim plugin that brings VSCode Claude extension functionality to Neovim.

## Features

- **VSCode-like Interface**: Sidebar chat interface similar to VSCode's Claude extension
- **Multi-file Editing**: Claude can suggest changes across multiple files
- **Diff Preview**: See changes before applying them
- **Context Awareness**: Automatically includes relevant files in context
- **Project Understanding**: Detects project type and structure
- **Smart Commands**: Quick commands for common tasks (explain, refactor, fix, etc.)

## Requirements

- Neovim 0.9+
- `plenary.nvim` (for HTTP requests)
- `ANTHROPIC_API_KEY` environment variable

## Installation

Using lazy.nvim, add the configuration from `plugins/claude-code.lua` to your plugins.

## Usage

### Basic Commands

- `<leader>cc` - Toggle Claude Code sidebar
- `<leader>cn` - Start new chat
- `<leader>ct` - Start new task
- `<Ctrl+Enter>` - Submit message (in sidebar)

### Code Actions

- `<leader>ce` - Explain selected code (visual mode)
- `<leader>cr` - Refactor selected code (visual mode)
- `<leader>cf` - Fix diagnostics in current file
- `<leader>cd` - Generate documentation
- `<leader>ct` - Generate tests

### Diff Management

- `]c` - Next diff
- `[c` - Previous diff
- `<leader>ca` - Accept all changes
- `<leader>cr` - Reject all changes
- `<leader>cd` - Accept current diff

### Context Management

- `<leader>cx` - Toggle current file in context
- Files are automatically included based on imports/relationships

## How It Works

1. **Context Building**: The plugin automatically detects related files (tests, imports, etc.) and includes them in the context sent to Claude.

2. **Diff Generation**: When Claude suggests code changes, they're presented as diffs that you can review before applying.

3. **Project Awareness**: Understands different project types (npm, Python, Rust, etc.) and provides relevant context.

## Example Workflow

1. Open a file you want to work on
2. Press `<leader>cc` to open Claude Code
3. Type your request (e.g., "Add error handling to this function")
4. Press `<Ctrl+Enter>` to submit
5. Review the suggested changes in the diff preview
6. Press `<leader>ca` to accept all changes or navigate with `]c`/`[c`

## Configuration

The plugin can be configured through the setup function:

```lua
require("claude-code").setup({
  api_key = os.getenv("ANTHROPIC_API_KEY"),
  model = "claude-3-5-sonnet-20241022",
  ui = {
    position = "right",  -- or "left", "bottom"
    width = 50,
  },
  features = {
    auto_context = true,
    project_awareness = true,
  }
})
```

## Tips

- Use visual selection to limit the scope of operations
- The plugin understands your project structure - it will include test files when working on source files
- You can manually add files to context with `<leader>cx`
- The diff preview updates as you navigate through changes

## Limitations

- Requires active internet connection
- API rate limits apply
- Large files may exceed token limits

## Future Enhancements

- Streaming responses
- Local model support
- Integration with LSP for better code understanding
- Custom prompt templates
- Session persistence