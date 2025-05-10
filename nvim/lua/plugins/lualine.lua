-- return {
--   -- Set lualine as statusline
--   'nvim-lualine/lualine.nvim',
--   -- See `:help lualine.txt`
--   opts = {
--     options = {
--       icons_enabled = false,
--       theme = 'one-dark',
--       component_separators = '|',
--       section_separators = '',
--     },
--   },
-- }
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = '|',
      section_separators = '',
    },
  },
}
