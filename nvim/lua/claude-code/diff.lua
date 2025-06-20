-- Diff handling for Claude Code
local M = {}

local config = {}
local state = {}

-- Current diff state
local diff_state = {
  pending_changes = {},
  current_index = 1,
  preview_buf = nil,
  preview_win = nil,
}

function M.setup(cfg)
  config = cfg
end

-- Process changes from Claude
function M.process_changes(changes)
  diff_state.pending_changes = {}
  
  for _, change in ipairs(changes) do
    local filepath = vim.fn.expand(change.file)
    
    -- Read current file content
    local current_content = ""
    if vim.fn.filereadable(filepath) == 1 then
      current_content = table.concat(vim.fn.readfile(filepath), "\n")
    end
    
    -- Create diff
    local diff = M._create_diff(current_content, change.content)
    
    table.insert(diff_state.pending_changes, {
      file = filepath,
      original = current_content,
      new_content = change.content,
      diff = diff,
      applied = false,
    })
  end
  
  -- Update UI
  state = require("claude-code").get_state()
  require("claude-code").update_state({ 
    pending_diffs = diff_state.pending_changes 
  })
  
  -- Show diff preview
  if config.ui.show_diff_preview and #diff_state.pending_changes > 0 then
    M.show_current_diff()
  end
  
  vim.notify(#diff_state.pending_changes .. " file(s) with changes", vim.log.levels.INFO)
end

-- Create a diff between two contents
function M._create_diff(old_content, new_content)
  -- Write to temp files
  local old_file = vim.fn.tempname()
  local new_file = vim.fn.tempname()
  
  vim.fn.writefile(vim.split(old_content, "\n"), old_file)
  vim.fn.writefile(vim.split(new_content, "\n"), new_file)
  
  -- Get diff
  local diff_cmd = string.format("diff -u %s %s", 
    vim.fn.shellescape(old_file), 
    vim.fn.shellescape(new_file))
  local diff_output = vim.fn.system(diff_cmd)
  
  -- Clean up
  vim.fn.delete(old_file)
  vim.fn.delete(new_file)
  
  return diff_output
end

-- Show current diff in preview
function M.show_current_diff()
  if #diff_state.pending_changes == 0 then return end
  
  local change = diff_state.pending_changes[diff_state.current_index]
  
  -- Create preview buffer
  if not diff_state.preview_buf or not vim.api.nvim_buf_is_valid(diff_state.preview_buf) then
    diff_state.preview_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(diff_state.preview_buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(diff_state.preview_buf, "filetype", "diff")
  end
  
  -- Set diff content
  local lines = {
    "File: " .. change.file,
    string.rep("─", 50),
    "",
  }
  
  for line in change.diff:gmatch("[^\n]+") do
    table.insert(lines, line)
  end
  
  vim.api.nvim_buf_set_lines(diff_state.preview_buf, 0, -1, false, lines)
  
  -- Open in split if not already open
  if not diff_state.preview_win or not vim.api.nvim_win_is_valid(diff_state.preview_win) then
    vim.cmd("topleft split")
    diff_state.preview_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(diff_state.preview_win, diff_state.preview_buf)
    vim.cmd("resize 15")
    
    -- Set window options
    vim.api.nvim_win_set_option(diff_state.preview_win, "number", false)
    vim.api.nvim_win_set_option(diff_state.preview_win, "relativenumber", false)
    vim.api.nvim_win_set_option(diff_state.preview_win, "signcolumn", "no")
    vim.api.nvim_win_set_option(diff_state.preview_win, "wrap", false)
  end
  
  -- Update status line
  vim.api.nvim_buf_set_name(diff_state.preview_buf, 
    string.format("Claude Changes [%d/%d]", diff_state.current_index, #diff_state.pending_changes))
end

-- Navigate to next diff
function M.next_diff()
  if #diff_state.pending_changes == 0 then return end
  
  diff_state.current_index = diff_state.current_index + 1
  if diff_state.current_index > #diff_state.pending_changes then
    diff_state.current_index = 1
  end
  
  M.show_current_diff()
end

-- Navigate to previous diff
function M.prev_diff()
  if #diff_state.pending_changes == 0 then return end
  
  diff_state.current_index = diff_state.current_index - 1
  if diff_state.current_index < 1 then
    diff_state.current_index = #diff_state.pending_changes
  end
  
  M.show_current_diff()
end

-- Accept current diff
function M.accept_current()
  if #diff_state.pending_changes == 0 then return end
  
  local change = diff_state.pending_changes[diff_state.current_index]
  if change.applied then
    vim.notify("Change already applied", vim.log.levels.WARN)
    return
  end
  
  -- Create directory if needed
  local dir = vim.fn.fnamemodify(change.file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  
  -- Write new content
  vim.fn.writefile(vim.split(change.new_content, "\n"), change.file)
  change.applied = true
  
  vim.notify("Applied changes to " .. vim.fn.fnamemodify(change.file, ":t"), vim.log.levels.INFO)
  
  -- Move to next unapplied change
  local unapplied = vim.tbl_filter(function(c) return not c.applied end, diff_state.pending_changes)
  if #unapplied > 0 then
    M.next_diff()
  else
    M.close_preview()
  end
end

-- Accept all diffs
function M.accept_all()
  if #diff_state.pending_changes == 0 then
    vim.notify("No pending changes", vim.log.levels.INFO)
    return
  end
  
  local count = 0
  for _, change in ipairs(diff_state.pending_changes) do
    if not change.applied then
      -- Create directory if needed
      local dir = vim.fn.fnamemodify(change.file, ":h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
      
      -- Write new content
      vim.fn.writefile(vim.split(change.new_content, "\n"), change.file)
      change.applied = true
      count = count + 1
    end
  end
  
  vim.notify("Applied " .. count .. " changes", vim.log.levels.INFO)
  
  -- Clear pending changes
  diff_state.pending_changes = {}
  require("claude-code").update_state({ pending_diffs = {} })
  
  -- Close preview
  M.close_preview()
  
  -- Close sidebar if configured
  if config.ui.auto_close_on_accept then
    require("claude-code.ui").close()
  end
end

-- Reject all diffs
function M.reject_all()
  diff_state.pending_changes = {}
  require("claude-code").update_state({ pending_diffs = {} })
  M.close_preview()
  vim.notify("Rejected all changes", vim.log.levels.INFO)
end

-- Close preview window
function M.close_preview()
  if diff_state.preview_win and vim.api.nvim_win_is_valid(diff_state.preview_win) then
    vim.api.nvim_win_close(diff_state.preview_win, true)
    diff_state.preview_win = nil
  end
end

return M