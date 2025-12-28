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
    
    -- Terminal configuration
    terminal = {
      win = {
        position = "float",
        border = "rounded",
        width = 0.9,
        height = 0.9,
        wo = {
          winblend = 0, -- No transparency
          winhighlight = "Normal:Normal,FloatBorder:Normal", -- Use normal background
        },
      },
    },
  },
  keys = {
    -- Command palette
    { "<leader>k",  function() require("snacks").picker.command_palette() end, desc = "Command Palette" },
    { "<leader>:",  function() require("snacks").picker.commands() end,        desc = "Commands" },

    -- Terminal - floating
    { "<leader>tt", function() require("snacks").terminal() end,               desc = "Toggle Terminal (float)" },
    { "<C-\\>",     function() require("snacks").terminal() end,               desc = "Toggle Terminal (float)", mode = {"n", "t"} },
    
    -- Terminal - splits
    { "<leader>th", function() require("snacks").terminal(nil, { win = { position = "bottom" } }) end, desc = "Toggle Terminal (horizontal)" },
    { "<leader>tv", function() require("snacks").terminal(nil, { win = { position = "right" } }) end,  desc = "Toggle Terminal (vertical)" },
    
    -- Terminal - specific commands
    { "<leader>gg", function() require("snacks").terminal("lazygit", { win = { border = "rounded" } }) end, desc = "Lazygit" },
    { "<leader>gl", function() require("snacks").terminal("lazygit log", { win = { border = "rounded" } }) end, desc = "Lazygit Log" },
    
    -- Multiple terminal sessions (using env to create separate terminals)
    { "<leader>t1", function() require("snacks").terminal(nil, { env = { SNACKS_TERM_ID = "1" } }) end, desc = "Terminal 1" },
    { "<leader>t2", function() require("snacks").terminal(nil, { env = { SNACKS_TERM_ID = "2" } }) end, desc = "Terminal 2" },
    { "<leader>t3", function() require("snacks").terminal(nil, { env = { SNACKS_TERM_ID = "3" } }) end, desc = "Terminal 3" },
    { "<leader>ts", function()
      local terminals = require("snacks").terminal.list()
      if #terminals == 0 then
        require("snacks").notify.warn("No terminals found")
        return
      end
      vim.ui.select(terminals, {
        prompt = "Select Terminal:",
        format_item = function(term)
          return string.format("%s (%s)", term.opts.id or "default", term.cmd or "shell")
        end,
      }, function(term)
        if term then term:show() end
      end)
    end, desc = "Select Terminal" },

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
        toggle.option("spell", { name = "Spelling" }):map("<leader>us")
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

