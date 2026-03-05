return {
  "milanglacier/minuet-ai.nvim",
  event = "InsertEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("minuet").setup({
      -- Use virtual text (ghost text) like Copilot did
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = { "env", "yaml", "markdown", "gitcommit", "NeogitCommitMessage" },
        keymap = {
          -- Matches old Copilot setup:
          -- Shift-Tab = accept full suggestion
          accept = "<S-Tab>",
          -- Tab = accept one line (closest to old accept_word behavior)
          accept_line = "<Tab>",
          -- Cycle suggestions
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        -- Don't show virtual text when cmp menu is open
        show_on_completion_menu = false,
      },

      -- Claude Haiku for fast, cheap completions
      provider = "claude",
      provider_options = {
        claude = {
          model = "claude-haiku-4.5",
          max_tokens = 256,
          api_key = "ANTHROPIC_API_KEY",
          stream = true,
        },
      },

      -- Performance tuning
      request_timeout = 3,
      throttle = 1000,
      debounce = 400,
      context_window = 16000,
      n_completions = 3,

      -- Don't notify on every request
      notify = "warn",
    })

    -- Custom Tab handler: when no Minuet suggestion visible, use normal Tab
    vim.keymap.set("i", "<Tab>", function()
      local vt = require("minuet.virtualtext")
      if vt.is_visible() then
        vt.accept_line()
      else
        return vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n",
          false
        )
      end
    end, { desc = "Accept Minuet line or normal Tab" })

    vim.keymap.set("i", "<S-Tab>", function()
      local vt = require("minuet.virtualtext")
      if vt.is_visible() then
        vt.accept()
      else
        return vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true),
          "n",
          false
        )
      end
    end, { desc = "Accept full Minuet suggestion" })
  end,
}
