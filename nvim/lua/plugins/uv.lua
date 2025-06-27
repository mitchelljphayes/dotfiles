return {
  "benomahony/uv.nvim",
  lazy = false,
  opts = {
    auto_activate_venv = true,
    picker_integration = true,
    keymaps = {
      prefix = "<leader>u",
      run_file = true,
      run_selection = true,
      run_cell = true,
      manage_packages = true,
    },
  },
  keys = {
    { "<leader>ua", "<cmd>UVActivateVenv<cr>", desc = "Activate virtual environment" },
    { "<leader>uc", "<cmd>UVCreateVenv<cr>", desc = "Create virtual environment" },
    { "<leader>us", "<cmd>UVSync<cr>", desc = "Sync dependencies" },
    { "<leader>up", "<cmd>UVPick<cr>", desc = "Pick Python interpreter" },
  },
}