return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
}
-- {
--   'Shatur/neovim-ayu',
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'ayu-mirage'
--   end,
-- }
