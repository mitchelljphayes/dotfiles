-- For copilot.vim
--[[ vim.g.copilot_filetypes = { ]]
--[[   xml = false, ]]
--[[   markdown = false, ]]
--[[   rust = false, ]]
--[[ } ]]
--[[]]
--[[ vim.cmd [[ ]]
--[[   imap <silent><script><expr> <C-A> copilot#Accept("\<CR>") ]]
--[[   let g:copilot_no_tab_map = v:true ]]
--[[]]
local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

copilot.setup {
  --[[ cmp = { ]]
  --[[   enabled = true, ]]
  --[[   method = "getCompletionsCycling", ]]
  --[[ }, ]]
  panel = { -- no config options yet
    enabled = true,
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
     accept = "<M-l>",
     next = "<M-]>",
     prev = "<M-[>",
     dismiss = "<C-]>",
    },
  },
  ft_disable = { "markdown" },
  copilot_node_command = 'node', -- Node version must be < 18
  plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
  server_opts_overrides = {
    settings = {
      advanced = {
        -- listCount = 10, -- #completions for panel
        inlineSuggestCount = 3, -- #completions for getCompletions
      },
    },
  },
}
