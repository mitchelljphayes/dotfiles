-- claude-nvim: A Neovim plugin for Claude AI integration
local M = {}

-- Default configuration
M.config = {
  api_key = os.getenv("ANTHROPIC_API_KEY"),
  model = "claude-3-5-sonnet-20250514", -- Claude Sonnet 4
  max_tokens = 4096,
  temperature = 0,
  system_prompt = "You are a helpful coding assistant integrated into Neovim. Be concise and code-focused.",
  keymaps = {
    open = "<leader>cc",
    accept_diff = "<leader>ca",
    reject_diff = "<leader>cr",
    toggle_diff = "<leader>cd",
  },
  ui = {
    width = 0.8,
    height = 0.8,
    prompt_height = 3,
    border = "rounded",
  }
}

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Set up commands
  M._setup_commands()
  
  -- Set up keymaps
  M._setup_keymaps()
end

-- Set up commands
function M._setup_commands()
  vim.api.nvim_create_user_command("Claude", function(opts)
    require("claude-nvim.ui").open(opts.args)
  end, { nargs = "?", desc = "Open Claude interface" })
end

-- Set up keymaps
function M._setup_keymaps()
  local keymaps = M.config.keymaps
  
  vim.keymap.set({"n", "v"}, keymaps.open, function()
    require("claude-nvim.ui").open()
  end, { desc = "Open Claude" })
end

return M