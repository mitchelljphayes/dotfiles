return {
  -- zen-mode.nvim for a more modern zen experience
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
      { "<leader>zm", function()
        -- Special zen mode for markdown that ensures render-markdown works
        require("zen-mode").toggle({
          plugins = {
            twilight = { enabled = false },
            render_markdown = { enabled = true },
          },
          on_open = function()
            vim.diagnostic.enable(false)
            -- Ensure proper conceallevel for markdown
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = ""
          end,
        })
      end, desc = "Zen Mode for Markdown" },
    },
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 120, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
        },
        twilight = { enabled = false }, -- disable twilight for better markdown visibility
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        -- ensure render-markdown keeps working
        render_markdown = { 
          enabled = true,
        },
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win)
        vim.diagnostic.enable(false)
      end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function()
        vim.diagnostic.enable(true)
      end,
    },
    dependencies = {
      -- Twilight dims inactive portions of the code
      {
        "folke/twilight.nvim",
        cmd = "Twilight",
        keys = {
          { "<leader>zt", "<cmd>Twilight<cr>", desc = "Toggle Twilight dimming" },
        },
        opts = {
          dimming = {
            alpha = 0.25, -- amount of dimming
            color = { "Normal", "#ffffff" },
            term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
            inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
          },
          context = 10, -- amount of lines we will try to show around the current line
          treesitter = true, -- use treesitter when available for the filetype
          expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "function",
            "method",
            "table",
            "if_statement",
          },
        },
      },
    },
  },
}