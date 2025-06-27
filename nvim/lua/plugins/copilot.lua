return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[p",  -- Changed from [[ to avoid conflict
            jump_next = "]p",  -- Changed from ]] to avoid conflict
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom",
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<S-Tab>",  -- Shift-Tab for full suggestion
            accept_word = false,  -- We'll handle this with custom mapping
            accept_line = false,  -- We'll handle this with custom mapping
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node',
        server_opts_overrides = {},
      })
      
      -- Custom Tab handler for Copilot
      -- Tab = accept word, Tab Tab = accept line, Shift-Tab = accept all
      local last_tab_time = 0
      local double_tap_timeout = 150 -- milliseconds
      
      vim.keymap.set('i', '<Tab>', function()
        local copilot = require('copilot.suggestion')
        
        if copilot.is_visible() then
          local current_time = vim.loop.now()
          local time_diff = current_time - last_tab_time
          
          if time_diff < double_tap_timeout then
            -- Double tab detected - accept line
            last_tab_time = 0 -- Reset
            copilot.accept_line()
          else
            -- Single tab - accept word
            last_tab_time = current_time
            copilot.accept_word()
          end
        else
          -- No Copilot suggestion, use default Tab behavior
          return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end
      end, { desc = "Accept Copilot word (double tap for line)" })
    end,
  },
  
  -- Copilot integration with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  },
}