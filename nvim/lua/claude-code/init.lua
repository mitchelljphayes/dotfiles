-- claude-code.nvim: Claude Code extension for Neovim
-- Provides similar functionality to the Claude Code VSCode extension

local M = {}

-- Default configuration
M.config = {
  api_key = os.getenv("ANTHROPIC_API_KEY"),
  model = "claude-sonnet-4-20250514", -- Claude Sonnet 4
  max_tokens = 8192,
  temperature = 0,
  keymaps = {
    toggle = "<leader>ct",         -- Toggle Claude Code sidebar
    new_chat = "<leader>cn",       -- New chat
    submit = "<C-Enter>",          -- Submit message
    accept_all = "<leader>ca",     -- Accept all changes
    reject_all = "<leader>cr",     -- Reject all changes
    next_diff = "]c",              -- Next diff
    prev_diff = "[c",              -- Previous diff
    accept_diff = "<leader>cd",    -- Accept current diff
    toggle_context = "<leader>cc", -- Toggle context inclusion
    hide = "<leader><Esc>",        -- Hide window (keep session)
  },
  ui = {
    position = "right",            -- right, left, bottom
    width = 50,                    -- Width in columns (for left/right)
    height = 20,                   -- Height in lines (for bottom)
    show_context = true,           -- Show file context by default
    show_diff_preview = true,      -- Show diff preview in real-time
    auto_close_on_accept = false,  -- Close after accepting all changes
  },
  features = {
    auto_context = true,           -- Automatically include relevant context
    inline_diffs = true,           -- Show diffs inline like VSCode
    multi_file_edit = true,        -- Support editing multiple files
    terminal_integration = true,   -- Terminal command suggestions
    project_awareness = true,      -- Understand project structure
  },
  use_local_claude = true,         -- Use local Claude Code CLI if available
}

-- State management
M.state = {
  sidebar_buf = nil,
  sidebar_win = nil,
  chat_history = {},
  current_task = nil,
  pending_diffs = {},
  context_files = {},
}

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Initialize components
  require("claude-code.api").setup(M.config)
  require("claude-code.commands").setup(M.config)
  require("claude-code.ui").setup(M.config)
  require("claude-code.context").setup(M.config)
  require("claude-code.diff").setup(M.config)
  require("claude-code.project").setup(M.config)
  
  -- Set up autocommands
  M._setup_autocmds()
  
  -- Set up keymaps
  M._setup_keymaps()
  
  -- Create user commands
  M._setup_commands()
end

-- Set up autocommands
function M._setup_autocmds()
  local group = vim.api.nvim_create_augroup("ClaudeCode", { clear = true })
  
  -- Auto-refresh context when changing buffers
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      if M.config.features.auto_context and M.state.sidebar_win then
        require("claude-code.context").refresh()
      end
    end,
  })
  
  -- Track file changes for multi-file awareness
  vim.api.nvim_create_autocmd({"BufWritePost", "BufNew"}, {
    group = group,
    callback = function(args)
      if M.config.features.project_awareness then
        require("claude-code.project").update_file(args.file)
      end
    end,
  })
end

-- Set up commands
function M._setup_commands()
  -- Main command
  vim.api.nvim_create_user_command("ClaudeCode", function(opts)
    local subcommand = opts.args
    if subcommand == "toggle" then
      M.toggle()
    elseif subcommand == "chat" then
      M.new_chat()
    elseif subcommand == "task" then
      M.new_task()
    elseif subcommand == "context" then
      require("claude-code.context").show()
    else
      M.toggle()
    end
  end, {
    nargs = "?",
    complete = function()
      return {"toggle", "chat", "task", "context"}
    end,
    desc = "Claude Code commands"
  })
  
  -- Convenience commands
  vim.api.nvim_create_user_command("ClaudeTask", function(opts)
    M.new_task(opts.args)
  end, { nargs = "*", desc = "Start a new Claude task" })
  
  vim.api.nvim_create_user_command("ClaudeFile", function(opts)
    -- Add current file to context and open
    require("claude-code.context").add_file(vim.fn.expand("%:p"))
    M.toggle()
  end, { desc = "Open Claude with current file" })
  
  vim.api.nvim_create_user_command("ClaudeAcceptAll", function()
    require("claude-code.diff").accept_all()
  end, { desc = "Accept all Claude suggestions" })
  
  vim.api.nvim_create_user_command("ClaudeRejectAll", function()
    require("claude-code.diff").reject_all()
  end, { desc = "Reject all Claude suggestions" })
  
  vim.api.nvim_create_user_command("ClaudeClose", function()
    require("claude-code.ui").close(true)
  end, { desc = "Close Claude session (end conversation)" })
end

-- Set up keymaps
function M._setup_keymaps()
  local keymaps = M.config.keymaps
  
  -- Global keymaps
  vim.keymap.set("n", keymaps.toggle, function() M.toggle() end, 
    { desc = "Toggle Claude Code" })
  vim.keymap.set("n", keymaps.new_chat, function() M.new_chat() end, 
    { desc = "New Claude chat" })
  vim.keymap.set("n", keymaps.accept_all, "<cmd>ClaudeAcceptAll<cr>", 
    { desc = "Accept all changes" })
  vim.keymap.set("n", keymaps.reject_all, "<cmd>ClaudeRejectAll<cr>", 
    { desc = "Reject all changes" })
  vim.keymap.set("n", keymaps.next_diff, function() 
    require("claude-code.diff").next_diff() 
  end, { desc = "Next diff" })
  vim.keymap.set("n", keymaps.prev_diff, function() 
    require("claude-code.diff").prev_diff() 
  end, { desc = "Previous diff" })
end

-- Toggle Claude Code sidebar
function M.toggle()
  require("claude-code.ui").toggle()
end

-- Start a new chat
function M.new_chat()
  require("claude-code.ui").new_chat()
end

-- Start a new task
function M.new_task(task_description)
  require("claude-code.ui").new_task(task_description)
end

-- Get current state (for other modules)
function M.get_state()
  return M.state
end

-- Update state
function M.update_state(updates)
  M.state = vim.tbl_deep_extend("force", M.state, updates)
end

return M