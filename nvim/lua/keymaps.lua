-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Comment
vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)",
  { noremap = true, silent = true, desc = 'Comment Line'})
vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)",
  { noremap = true, silent = true, desc = 'Comment selected lines'})

-- Oil
vim.keymap.set("n", "<leader>-","<CMD>Oil<CR>", { desc = "Open oil" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Normal --
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })

-- Move text up and down
vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<CR>=g<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<CR>==g<Esc>", { noremap = true, silent = true })

-- file explorer
-- vim.keymap.set("n", "<leader>\\", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })
-- Insert --
-- Press jk fast to enter
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
