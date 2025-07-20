return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  config = function()
    -- Try to force unified diff view
    vim.opt.diffopt:append("internal")
    vim.opt.diffopt:append("algorithm:patience")
    vim.opt.diffopt:append("indent-heuristic")
    
    require("diffview").setup({
      view = {
        -- Configure the layout and behavior of different types of views.
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff1_plain", -- Unified diff in single window
          disable_win_separator = true,
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff1_plain",
        },
      },
      diff_binaries = false,
      enhanced_diff_hl = true, -- Better highlighting
      git_cmd = { "git" },
      use_icons = true,
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
        file_panel = {
          { "n", "j", "j", { desc = "Next entry" } },
          { "n", "k", "k", { desc = "Previous entry" } },
          { "n", "<cr>", "<cmd>DiffviewFocusFile<cr>", { desc = "Open diff" } },
          { "n", "s", "<cmd>DiffviewToggleStage<cr>", { desc = "Stage/unstage" } },
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    })
  end,
}