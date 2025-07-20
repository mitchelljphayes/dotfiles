return {
  -- Seamless navigation between tmux panes and vim splits
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      -- Disable default mappings
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<M-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<M-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<M-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
      { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous" },
    },
  },
}