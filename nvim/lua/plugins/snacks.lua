return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable the features you want
    bigfile = { enabled = true },
    dashboard = { enabled = false }, -- Disable if you have your own dashboard
    indent = { enabled = false },    -- Disable if you prefer your current indent guides
    -- input = { enabled = true }, -- Better vim.ui.input
    -- notifier = { enabled = true }, -- Better notifications
    quickfile = { enabled = true },
    scroll = { enabled = false },       -- Smooth scrolling
    statuscolumn = { enabled = false }, -- Keep your current statuscolumn
    words = { enabled = true },         -- Highlight word under cursor

    -- Command palette configuration
    picker = {
      enabled = true,
      sources = {
        { name = "commands",        weight = 3 },
        { name = "command_history", weight = 2 },
        { name = "files",           weight = 1 },
      },
    },

    -- Input configuration for Telescope-like behavior
    input = {
      prompt = " ",
      icon = " ",
      icon_hl = "SnacksInputIcon",
      win = {
        style = "float",
        border = "rounded",
        title_pos = "center",
        relative = "cursor",
        row = 1,
        col = 0,
        width = 0.4,
        height = 1,
        wo = {
          winblend = 10,
          winhighlight = "Normal:Normal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
        },
      },
      -- Use telescope-like keymaps
      keys = {
        i_esc = { "<esc>", mode = "i", "cancel" },
        i_cr = { "<cr>", mode = "i", "confirm" },
        i_tab = { "<tab>", mode = "i", "next" },
        i_s_tab = { "<s-tab>", mode = "i", "prev" },
        n_esc = { "<esc>", mode = "n", "cancel" },
        n_cr = { "<cr>", mode = "n", "confirm" },
      },
    },

    -- Notification configuration
    notifier = {
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      style = "fancy", -- "compact", "fancy", "minimal"
    },
  },
  keys = {
    -- Command palette
    { "<leader>k",  function() require("snacks").picker.command_palette() end, desc = "Command Palette" },
    { "<leader>:",  function() require("snacks").picker.commands() end,        desc = "Commands" },

    -- Notifications
    { "<leader>un", function() require("snacks").notifier.hide() end,          desc = "Dismiss All Notifications" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end,  desc = "Notification History" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          require("snacks").debug.inspect(...)
        end
        _G.bt = function()
          require("snacks").debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for better output

        -- Create some toggle commands
        local toggle = require("snacks").toggle
        toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
        toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
        toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        toggle.diagnostics():map("<leader>td")
        toggle.line_number():map("<leader>tl")
        toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
        "<leader>tc")
        toggle.treesitter():map("<leader>tT")
      end,
    })
  end,
}

