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

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<CMD>bd<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>q", "<CMD>q<CR>", { desc = "Close window" })

-- Claude Code positioning
vim.keymap.set("n", "<leader>cl", "<CMD>ClaudeCodeLeft<CR>", { desc = "Move Claude Code to left" })

-- Diffview
vim.keymap.set("n", "<leader>dv", "<CMD>DiffviewOpen<CR>", { desc = "Open diffview" })
vim.keymap.set("n", "<leader>dh", "<CMD>DiffviewFileHistory %<CR>", { desc = "File history (current file)" })
vim.keymap.set("n", "<leader>dH", "<CMD>DiffviewFileHistory<CR>", { desc = "File history (all files)" })
vim.keymap.set("n", "<leader>dc", "<CMD>DiffviewClose<CR>", { desc = "Close diffview" })

-- Delta diff viewer (requires delta to be installed)
vim.keymap.set("n", "<leader>dd", function()
  local file = vim.fn.expand("%:p")
  if file ~= "" then
    vim.cmd("tabnew | terminal git diff -- " .. vim.fn.shellescape(file))
  else
    vim.cmd("tabnew | terminal git diff")
  end
  vim.cmd("startinsert")
end, { desc = "View current file diff in delta" })

vim.keymap.set("n", "<leader>da", function()
  vim.cmd("tabnew | terminal git diff")
  vim.cmd("startinsert")
end, { desc = "View all diffs in delta" })

-- Oil diagnostic refresh
vim.keymap.set("n", "<leader>or", function()
  -- Force redraw all Oil buffers
  local oil_refreshed = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "oil" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("e")  -- Reload the buffer
      end)
      oil_refreshed = true
    end
  end
  if oil_refreshed then
    vim.notify("Oil buffers refreshed", vim.log.levels.INFO)
  else
    vim.notify("No Oil buffers to refresh", vim.log.levels.WARN)
  end
end, { desc = "Refresh Oil buffers" })

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
-- Ctrl+hjkl for normal window navigation (when not in tmux)
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- Note: Alt+hjkl are handled by vim-tmux-navigator plugin for seamless tmux integration

-- Arrow key window navigation (useful when C-hjkl is remapped to arrows at system level)
vim.keymap.set("n", "<Left>", "<C-w>h", { noremap = true, silent = true, desc = "Window left" })
vim.keymap.set("n", "<Right>", "<C-w>l", { noremap = true, silent = true, desc = "Window right" })
vim.keymap.set("n", "<Up>", "<C-w>k", { noremap = true, silent = true, desc = "Window up" })
vim.keymap.set("n", "<Down>", "<C-w>j", { noremap = true, silent = true, desc = "Window down" })

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

-- Copy diagnostics for current buffer to clipboard
vim.keymap.set("n", "<leader>cd", function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("No diagnostics in current buffer")
    return
  end
  
  local lines = {}
  for _, d in ipairs(diagnostics) do
    table.insert(lines, string.format("%s:%d:%d: %s [%s]", 
      vim.fn.expand("%:t"), 
      d.lnum + 1, 
      d.col + 1,
      d.message,
      d.source or "unknown"
    ))
  end
  
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Copied " .. #diagnostics .. " diagnostics to clipboard")
end, { desc = "Copy diagnostics to clipboard" })

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
