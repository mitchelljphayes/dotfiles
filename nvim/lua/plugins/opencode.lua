return {
  -- OpenCode - AI coding assistant integration for Neovim
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}

      vim.o.autoread = true

      -- Keymaps matching old Claude Code layout where possible
      vim.keymap.set({ "n", "x" }, "<leader>cc", function() require("opencode").toggle() end, { desc = "Toggle OpenCode" })
      vim.keymap.set({ "n", "x" }, "<leader>ca", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask OpenCode about this" })
      vim.keymap.set({ "n", "x" }, "<leader>cf", function() require("opencode").select() end, { desc = "OpenCode actions" })

      -- Operator for sending ranges
      vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Send range to OpenCode", expr = true })
      vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Send line to OpenCode", expr = true })

      -- Terminal mode
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
    keys = {
      { "<leader>cc", desc = "Toggle OpenCode" },
      { "<leader>ca", desc = "Ask OpenCode about this" },
      { "<leader>cf", desc = "OpenCode actions" },
    },
  },
}
