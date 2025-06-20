return {
  -- Claude Code - VSCode-like Claude integration for Neovim
  {
    "claude-code",
    dir = vim.fn.stdpath("config") .. "/lua/claude-code",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For HTTP requests
      "MunifTanjim/nui.nvim",  -- For better UI components (optional)
    },
    config = function()
      require("claude-code").setup({
        api_key = os.getenv("ANTHROPIC_API_KEY"),
        model = "claude-sonnet-4-20250514", -- Claude Sonnet 4
        keymaps = {
          toggle = "<leader>cc",         -- Toggle Claude Code sidebar
          new_chat = "<leader>cn",       -- New chat
          submit = "<C-Enter>",          -- Submit message
          accept_all = "<leader>ca",     -- Accept all changes
          reject_all = "<leader>cr",     -- Reject all changes
          next_diff = "]c",              -- Next diff
          prev_diff = "[c",              -- Previous diff
          accept_diff = "<leader>cd",    -- Accept current diff
          toggle_context = "<leader>cx", -- Toggle context inclusion
        },
        ui = {
          position = "right",            -- right, left, bottom
          width = 50,                    -- Width in columns
          height = 20,                   -- Height in lines (for bottom)
          show_context = true,           -- Show file context
          show_diff_preview = true,      -- Show diff preview
          auto_close_on_accept = false,  -- Close after accepting changes
        },
        features = {
          auto_context = true,           -- Auto-include relevant files
          inline_diffs = true,           -- Show diffs inline
          multi_file_edit = true,        -- Support multi-file edits
          terminal_integration = false,  -- Terminal command suggestions
          project_awareness = true,      -- Understand project structure
        }
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode toggle<cr>", desc = "Toggle Claude Code" },
      { "<leader>ct", "<cmd>ClaudeTask<cr>", desc = "New Claude task" },
      { "<leader>ce", "<cmd>ClaudeExplain<cr>", mode = "v", desc = "Explain code" },
      { "<leader>cr", "<cmd>ClaudeRefactor<cr>", mode = "v", desc = "Refactor code" },
      { "<leader>cf", "<cmd>ClaudeFix<cr>", desc = "Fix diagnostics" },
      { "<leader>cd", "<cmd>ClaudeDoc<cr>", mode = { "n", "v" }, desc = "Generate docs" },
    },
  },
}