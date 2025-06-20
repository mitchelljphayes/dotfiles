-- UI module for Claude Code
local M = {}
local api = vim.api
local buf_utils = require("claude-code.buffer_utils")

local config = {}
local state = {}

function M.setup(cfg)
  config = cfg
end

-- Toggle the sidebar
function M.toggle()
  state = require("claude-code").get_state()
  
  if state.sidebar_win and api.nvim_win_is_valid(state.sidebar_win) then
    M.close()
  else
    M.open()
  end
end

-- Open the sidebar
function M.open()
  state = require("claude-code").get_state()
  
  -- Create buffer if it doesn't exist
  if not state.sidebar_buf or not api.nvim_buf_is_valid(state.sidebar_buf) then
    state.sidebar_buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_name(state.sidebar_buf, "Claude Code")
    
    -- Set buffer options
    local buf = state.sidebar_buf
    api.nvim_buf_set_option(buf, "buftype", "nofile")
    api.nvim_buf_set_option(buf, "swapfile", false)
    api.nvim_buf_set_option(buf, "bufhidden", "hide")
    api.nvim_buf_set_option(buf, "filetype", "claude-code")
    
    -- Set up buffer-local keymaps
    M._setup_buffer_keymaps(buf)
  end
  
  -- Calculate window size
  local width = config.ui.width
  local height = config.ui.height
  
  if config.ui.position == "right" or config.ui.position == "left" then
    width = math.min(width, math.floor(vim.o.columns * 0.5))
  else
    height = math.min(height, math.floor(vim.o.lines * 0.5))
  end
  
  -- Create window
  local win_opts = {
    relative = "editor",
    style = "minimal",
    border = "none",
  }
  
  if config.ui.position == "right" then
    win_opts.anchor = "NE"
    win_opts.row = 0
    win_opts.col = vim.o.columns
    win_opts.width = width
    win_opts.height = vim.o.lines - 2
  elseif config.ui.position == "left" then
    win_opts.anchor = "NW"
    win_opts.row = 0
    win_opts.col = 0
    win_opts.width = width
    win_opts.height = vim.o.lines - 2
  else -- bottom
    win_opts.anchor = "SW"
    win_opts.row = vim.o.lines - 1
    win_opts.col = 0
    win_opts.width = vim.o.columns
    win_opts.height = height
  end
  
  -- Create split instead of floating window for better integration
  local cmd = config.ui.position == "right" and "botright vsplit" or
              config.ui.position == "left" and "topleft vsplit" or
              "botright split"
  
  vim.cmd(cmd)
  state.sidebar_win = api.nvim_get_current_win()
  
  -- Set window size
  if config.ui.position == "right" or config.ui.position == "left" then
    vim.cmd("vertical resize " .. width)
  else
    vim.cmd("resize " .. height)
  end
  
  -- Set buffer
  api.nvim_win_set_buf(state.sidebar_win, state.sidebar_buf)
  
  -- Set window options
  api.nvim_win_set_option(state.sidebar_win, "number", false)
  api.nvim_win_set_option(state.sidebar_win, "relativenumber", false)
  api.nvim_win_set_option(state.sidebar_win, "signcolumn", "no")
  api.nvim_win_set_option(state.sidebar_win, "winfixwidth", true)
  
  -- Render initial content
  M.render()
  
  -- Update state
  require("claude-code").update_state({ 
    sidebar_buf = state.sidebar_buf,
    sidebar_win = state.sidebar_win 
  })
  
  -- Focus on input area
  M._focus_input()
end

-- Close the sidebar
function M.close()
  state = require("claude-code").get_state()
  
  if state.sidebar_win and api.nvim_win_is_valid(state.sidebar_win) then
    api.nvim_win_close(state.sidebar_win, true)
  end
  
  require("claude-code").update_state({ sidebar_win = nil })
end

-- Render the UI
function M.render()
  state = require("claude-code").get_state()
  if not state.sidebar_buf then return end
  
  local lines = {}
  local highlights = {}
  
  -- Header
  table.insert(lines, " Claude Code")
  table.insert(lines, " " .. string.rep("─", config.ui.width - 2))
  table.insert(highlights, {line = 0, col = 1, end_col = 12, hl_group = "ClaudeCodeHeader"})
  
  -- Context indicator
  if config.ui.show_context then
    local context = require("claude-code.context").get_current()
    table.insert(lines, "")
    table.insert(lines, " Context: " .. #context.files .. " files")
    for i, file in ipairs(context.files) do
      if i <= 3 then
        table.insert(lines, "   • " .. vim.fn.fnamemodify(file, ":t"))
      end
    end
    if #context.files > 3 then
      table.insert(lines, "   • ...")
    end
  end
  
  -- Chat history
  table.insert(lines, "")
  table.insert(lines, " " .. string.rep("─", config.ui.width - 2))
  table.insert(lines, " Chat")
  table.insert(lines, "")
  
  for _, message in ipairs(state.chat_history) do
    if message.role == "user" then
      table.insert(lines, " You: " .. message.content:gsub("\n", "\n      "))
      table.insert(highlights, {
        line = #lines - 1, 
        col = 1, 
        end_col = 5, 
        hl_group = "ClaudeCodeUser"
      })
    else
      table.insert(lines, " Claude: " .. message.content:gsub("\n", "\n         "))
      table.insert(highlights, {
        line = #lines - 1, 
        col = 1, 
        end_col = 8, 
        hl_group = "ClaudeCodeAssistant"
      })
    end
    table.insert(lines, "")
  end
  
  -- Pending diffs indicator
  if #state.pending_diffs > 0 then
    table.insert(lines, " " .. string.rep("─", config.ui.width - 2))
    table.insert(lines, " Pending Changes: " .. #state.pending_diffs)
    table.insert(lines, " Press " .. config.keymaps.accept_all .. " to accept all")
    table.insert(lines, "")
  end
  
  -- Input area
  table.insert(lines, " " .. string.rep("─", config.ui.width - 2))
  table.insert(lines, " Message (Press " .. config.keymaps.submit .. " to send):")
  table.insert(lines, " > ")
  
  -- Set lines
  api.nvim_buf_set_option(state.sidebar_buf, "modifiable", true)
  api.nvim_buf_set_lines(state.sidebar_buf, 0, -1, false, lines)
  
  -- Apply highlights
  for _, hl in ipairs(highlights) do
    api.nvim_buf_add_highlight(
      state.sidebar_buf, 
      -1, 
      hl.hl_group, 
      hl.line, 
      hl.col, 
      hl.end_col
    )
  end
  
  api.nvim_buf_set_option(state.sidebar_buf, "modifiable", true)
end

-- Set up buffer-local keymaps
function M._setup_buffer_keymaps(buf)
  -- We need to set keymaps after the buffer is displayed in a window
  vim.schedule(function()
    if not api.nvim_buf_is_valid(buf) then return end
    
    -- Use vim.keymap.set with buffer option
    local opts = { noremap = true, silent = true, buffer = buf }
    
    -- Submit on Ctrl+Enter
    vim.keymap.set("i", config.keymaps.submit, 
      function() require('claude-code.ui').submit() end, opts)
    vim.keymap.set("n", config.keymaps.submit, 
      function() require('claude-code.ui').submit() end, opts)
    
    -- Close on q
    vim.keymap.set("n", "q", 
      function() require('claude-code.ui').close() end, opts)
    
    -- Toggle context
    vim.keymap.set("n", config.keymaps.toggle_context,
      function() require('claude-code.context').toggle_file() end, opts)
  end)
end

-- Focus on the input area
function M._focus_input()
  state = require("claude-code").get_state()
  if not state.sidebar_win or not api.nvim_win_is_valid(state.sidebar_win) then
    return
  end
  
  -- Move cursor to input line
  local line_count = api.nvim_buf_line_count(state.sidebar_buf)
  api.nvim_win_set_cursor(state.sidebar_win, {line_count, 3})
  vim.cmd("startinsert!")
end

-- Submit the current message
function M.submit()
  state = require("claude-code").get_state()
  if not state.sidebar_buf then return end
  
  -- Get the input text
  local lines = api.nvim_buf_get_lines(state.sidebar_buf, 0, -1, false)
  local input_start = nil
  
  -- Find the input line
  for i = #lines, 1, -1 do
    if lines[i]:match("^ > ") then
      input_start = i
      break
    end
  end
  
  if not input_start then return end
  
  -- Extract message
  local message = lines[input_start]:sub(4) -- Remove " > " prefix
  if message == "" then return end
  
  -- Add to chat history
  table.insert(state.chat_history, {
    role = "user",
    content = message
  })
  
  -- Update state
  require("claude-code").update_state({ chat_history = state.chat_history })
  
  -- Re-render to show user message
  M.render()
  
  -- Send to Claude
  require("claude-code.api").send_message(message, function(response)
    if response.error then
      vim.notify("Claude error: " .. response.error, vim.log.levels.ERROR)
      return
    end
    
    -- Add response to chat history
    table.insert(state.chat_history, {
      role = "assistant",
      content = response.content
    })
    
    -- Process any code changes
    if response.changes then
      require("claude-code.diff").process_changes(response.changes)
    end
    
    -- Update state and re-render
    require("claude-code").update_state({ chat_history = state.chat_history })
    M.render()
    M._focus_input()
  end)
end

-- Start a new chat
function M.new_chat()
  state = require("claude-code").get_state()
  state.chat_history = {}
  require("claude-code").update_state({ chat_history = {} })
  
  if not state.sidebar_win then
    M.open()
  else
    M.render()
    M._focus_input()
  end
end

-- Start a new task
function M.new_task(task_description)
  M.new_chat()
  
  if task_description and task_description ~= "" then
    -- Simulate typing the task
    vim.schedule(function()
      state = require("claude-code").get_state()
      if state.sidebar_win and api.nvim_win_is_valid(state.sidebar_win) then
        local line_count = api.nvim_buf_line_count(state.sidebar_buf)
        api.nvim_buf_set_lines(
          state.sidebar_buf, 
          line_count - 1, 
          line_count, 
          false, 
          {" > " .. task_description}
        )
        M.submit()
      end
    end)
  end
end

-- Define highlight groups
function M.define_highlights()
  vim.cmd([[
    hi def ClaudeCodeHeader guifg=#61afef gui=bold
    hi def ClaudeCodeUser guifg=#98c379 gui=bold
    hi def ClaudeCodeAssistant guifg=#e06c75 gui=bold
    hi def link ClaudeCodeContext Comment
    hi def link ClaudeCodeDiff DiffText
  ]])
end

-- Initialize highlights
M.define_highlights()

return M