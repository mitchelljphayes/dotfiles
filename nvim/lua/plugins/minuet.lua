return {
  "milanglacier/minuet-ai.nvim",
  enabled = true,
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
          -- Disable minuet's built-in keymaps; we handle Tab/S-Tab ourselves
          accept = nil,
          accept_line = nil,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        -- Don't show virtual text when cmp menu is open
        show_on_completion_menu = false,
      },

      -- Ollama Cloud for completions
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          end_point = "http://localhost:11434/v1/chat/completions",
          api_key = "TERM",
          name = "Ollama Cloud",
          model = "glm-5.2:cloud",
          stream = false, -- GLM 5.2 puts completions in reasoning field when streaming; use non-streaming
          optional = {
            max_tokens = 256,
            temperature = 0.2,
          },
        },
      },

      -- Performance tuning
      request_timeout = 10,
      throttle = 1000,
      debounce = 400,
      context_window = 16000,
      n_completions = 3,

      -- Don't notify on every request
      notify = "warn",

      cmp = {
        enable_auto_complete = true,
      },
    })

    -- NOTE: Minuet handles its own keymaps internally via virtualtext.keymap config above.
    -- Do NOT set custom <Tab>/<S-Tab> keymaps here — they shadow Minuet's built-in handlers
    -- and break completion acceptance. The keymap table in setup() is the correct place to configure.
  end,
}
