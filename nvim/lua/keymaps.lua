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

-- Molten
vim.keymap.set("n", "<leader>ip", function()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd("MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })


-- Normal --
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
-- C-j and C-k are handled by smart navigation below
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

-- Quickfix navigation
vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item" })

-- Smart navigation: use Ctrl-j/k for quickfix when quickfix is open, otherwise for windows
vim.keymap.set("n", "<C-j>", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd("cnext")
  else
    vim.cmd("wincmd j")
  end
end, { desc = "Next quickfix item or window down" })

vim.keymap.set("n", "<C-k>", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd("cprev")
  else
    vim.cmd("wincmd k")
  end
end, { desc = "Previous quickfix item or window up" })

-- Location list navigation
vim.keymap.set("n", "]l", ":lnext<CR>", { desc = "Next location list item" })
vim.keymap.set("n", "[l", ":lprev<CR>", { desc = "Previous location list item" })

-- When in quickfix or location list window, use simple j/k
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    vim.keymap.set("n", "j", "j", { buffer = true })
    vim.keymap.set("n", "k", "k", { buffer = true })
    vim.keymap.set("n", "<C-j>", "j", { buffer = true })
    vim.keymap.set("n", "<C-k>", "k", { buffer = true })
    vim.keymap.set("n", "<Down>", "j", { buffer = true })
    vim.keymap.set("n", "<Up>", "k", { buffer = true })
  end,
})
