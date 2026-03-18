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
    vim.opt.diffopt:append("internal")
    vim.opt.diffopt:append("algorithm:patience")
    vim.opt.diffopt:append("indent-heuristic")

    -- Toggle between unified (single pane) and side-by-side layouts
    local side_by_side = false

    local function current_layout()
      return side_by_side and "diff2_horizontal" or "diff1_plain"
    end

    local function toggle_layout()
      side_by_side = not side_by_side
      require("diffview").setup({
        view = {
          default = { layout = current_layout(), disable_diagnostics = true },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
          file_history = { layout = current_layout() },
        },
      })
      -- Reopen current diffview to apply the new layout
      local info = require("diffview.lib").get_current_view()
      if info then
        local cmd = info.adapter and info.adapter.ctx and info.adapter.ctx.toplevel
        vim.cmd("DiffviewClose")
        vim.schedule(function()
          vim.cmd("DiffviewOpen")
        end)
      end
      local mode = side_by_side and "side-by-side" or "unified"
      vim.notify("Diffview layout: " .. mode, vim.log.levels.INFO)
    end

    vim.api.nvim_create_user_command("DiffviewToggleLayout", toggle_layout, { desc = "Toggle unified/side-by-side" })
    vim.keymap.set("n", "<leader>d2", toggle_layout, { desc = "Toggle diff layout (unified/split)" })

    require("diffview").setup({
      view = {
        default = {
          layout = current_layout(),
          disable_diagnostics = true,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
        file_history = {
          layout = current_layout(),
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