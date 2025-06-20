-- Context management for Claude Code
local M = {}

local config = {}
local context = {
  files = {},
  auto_included = {},
}

function M.setup(cfg)
  config = cfg
end

-- Get current context
function M.get_current()
  return context
end

-- Add a file to context
function M.add_file(filepath)
  filepath = vim.fn.expand(filepath)
  if not vim.tbl_contains(context.files, filepath) then
    table.insert(context.files, filepath)
    M._update_ui()
  end
end

-- Remove a file from context
function M.remove_file(filepath)
  filepath = vim.fn.expand(filepath)
  for i, file in ipairs(context.files) do
    if file == filepath then
      table.remove(context.files, i)
      M._update_ui()
      break
    end
  end
end

-- Toggle current file in context
function M.toggle_file()
  local current_file = vim.fn.expand("%:p")
  if vim.tbl_contains(context.files, current_file) then
    M.remove_file(current_file)
    vim.notify("Removed from context: " .. vim.fn.fnamemodify(current_file, ":t"))
  else
    M.add_file(current_file)
    vim.notify("Added to context: " .. vim.fn.fnamemodify(current_file, ":t"))
  end
end

-- Clear all context
function M.clear()
  context.files = {}
  context.auto_included = {}
  M._update_ui()
end

-- Refresh context (auto-include related files)
function M.refresh()
  if not config.features.auto_context then
    return
  end
  
  -- Get current file
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then return end
  
  -- Clear auto-included files
  context.auto_included = {}
  
  -- Auto-include based on various heuristics
  local auto_files = {}
  
  -- 1. Include test files for source files and vice versa
  if current_file:match("_test%.") or current_file:match("_spec%.") then
    -- This is a test file, try to find the source
    local source = current_file:gsub("_test%.", "."):gsub("_spec%.", ".")
    if vim.fn.filereadable(source) == 1 then
      table.insert(auto_files, source)
    end
  else
    -- This is a source file, try to find tests
    local base = vim.fn.fnamemodify(current_file, ":r")
    local ext = vim.fn.fnamemodify(current_file, ":e")
    local test_patterns = {base .. "_test." .. ext, base .. "_spec." .. ext}
    
    for _, pattern in ipairs(test_patterns) do
      if vim.fn.filereadable(pattern) == 1 then
        table.insert(auto_files, pattern)
      end
    end
  end
  
  -- 2. Include related files based on imports/requires
  local content = table.concat(vim.fn.readfile(current_file), "\n")
  
  -- Python imports
  for module in content:gmatch("from%s+(%S+)%s+import") do
    local possible_file = vim.fn.fnamemodify(current_file, ":h") .. "/" .. module:gsub("%.", "/") .. ".py"
    if vim.fn.filereadable(possible_file) == 1 then
      table.insert(auto_files, possible_file)
    end
  end
  
  -- JavaScript/TypeScript imports
  for module in content:gmatch("from%s+['\"]([^'\"]+)['\"]") do
    local dir = vim.fn.fnamemodify(current_file, ":h")
    local possible_files = {
      dir .. "/" .. module .. ".js",
      dir .. "/" .. module .. ".ts",
      dir .. "/" .. module .. "/index.js",
      dir .. "/" .. module .. "/index.ts",
    }
    
    for _, file in ipairs(possible_files) do
      if vim.fn.filereadable(file) == 1 then
        table.insert(auto_files, file)
        break
      end
    end
  end
  
  -- Add auto-included files
  for _, file in ipairs(auto_files) do
    if not vim.tbl_contains(context.files, file) and 
       not vim.tbl_contains(context.auto_included, file) then
      table.insert(context.auto_included, file)
    end
  end
  
  M._update_ui()
end

-- Get all context files (manual + auto)
function M.get_all_files()
  local all_files = vim.deepcopy(context.files)
  for _, file in ipairs(context.auto_included) do
    table.insert(all_files, file)
  end
  return all_files
end

-- Update UI when context changes
function M._update_ui()
  local state = require("claude-code").get_state()
  if state.sidebar_win and vim.api.nvim_win_is_valid(state.sidebar_win) then
    require("claude-code.ui").render()
  end
end

-- Show context in a floating window
function M.show()
  local files = M.get_all_files()
  if #files == 0 then
    vim.notify("No files in context", vim.log.levels.INFO)
    return
  end
  
  local lines = {"Current Context Files:"}
  for _, file in ipairs(context.files) do
    table.insert(lines, "  • " .. vim.fn.fnamemodify(file, ":~:."))
  end
  
  if #context.auto_included > 0 then
    table.insert(lines, "")
    table.insert(lines, "Auto-included:")
    for _, file in ipairs(context.auto_included) do
      table.insert(lines, "  ◦ " .. vim.fn.fnamemodify(file, ":~:."))
    end
  end
  
  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  
  local width = math.min(60, math.max(30, #lines + 4))
  local height = #lines + 2
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    border = "rounded",
    title = " Context Files ",
    title_pos = "center",
  })
  
  -- Close on any key
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", 
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", 
    { noremap = true, silent = true })
end

return M