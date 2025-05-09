return {
  "navarasu/onedark.nvim",
  name = "onedark",
  priority = 1000,
  style = "darker",
  config = function()
    vim.cmd.colorscheme 'onedark'
  end,
}
-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'catppuccin'
--   end,
-- }
-- {
--   'Shatur/neovim-ayu',
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'ayu-mirage'
--   end,
-- }
-- 
-- return {
--   "EdenEast/nightfox.nvim",
--   name = "carbonfox",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'carbonfox'
--   end,
-- }
