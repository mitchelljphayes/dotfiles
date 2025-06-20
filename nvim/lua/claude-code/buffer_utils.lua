-- Buffer utilities for Claude Code
local M = {}

-- Create a scratch buffer
function M.create_scratch_buffer(name)
  local buf = vim.api.nvim_create_buf(false, true)
  if name then
    vim.api.nvim_buf_set_name(buf, name)
  end
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
  return buf
end

-- Create a floating window
function M.create_float(buf, opts)
  opts = opts or {}
  
  local width = opts.width or 80
  local height = opts.height or 20
  
  -- Calculate position
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local win_opts = {
    relative = opts.relative or "editor",
    row = opts.row or row,
    col = opts.col or col,
    width = width,
    height = height,
    border = opts.border or "rounded",
    style = opts.style or "minimal",
  }
  
  if opts.title then
    win_opts.title = opts.title
    win_opts.title_pos = opts.title_pos or "center"
  end
  
  return vim.api.nvim_open_win(buf, true, win_opts)
end

return M