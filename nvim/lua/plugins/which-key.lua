-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  opts = {
    defaults = {
      ["<leader>z"] = { name = "+zen", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "+markdown", _ = "which_key_ignore" },
      ["<leader>c"] = { name = "+code", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "+toggle", _ = "which_key_ignore" },
    },
  },
}
