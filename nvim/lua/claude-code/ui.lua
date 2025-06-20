-- UI module for Claude Code
local M = {}
local api = vim.api

local config = {}
local state = {
  prompt_buf = nil,
  prompt_win = nil,
  history_buf = nil,
  history_win = nil,
  term_buf = nil,
  term_win = nil,
  active = false,
}

function M.setup(cfg)
  config = cfg
end

-- Toggle the floating window
function M.toggle()
  if state.active then
    M.close()
  else
    M.open()
  end
end

-- Open the floating window
function M.open()
  if state.active then return end
  
  -- Check if local Claude Code CLI is available
  local claude_cmd = vim.fn.expand("~/.claude/local/claude")
  if not (config.use_local_claude ~= false and vim.fn.executable(claude_cmd) == 1) then
    -- Fall back to API-based UI if CLI not available
    M._open_api_ui()
    return
  end
  
  -- Get window dimensions
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  -- Create terminal buffer
  state.term_buf = api.nvim_create_buf(false, true)
  
  -- Create floating window
  state.term_win = api.nvim_open_win(state.term_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Claude Code ",
    title_pos = "center",
  })
  
  -- Get context files
  local context = require("claude-code.context").get_current()
  local cmd = {claude_cmd}
  
  -- Add context files as arguments
  for _, file in ipairs(context.files) do
    table.insert(cmd, file)
  end
  
  -- Start terminal with Claude CLI
  local term_cmd = table.concat(cmd, " ")
  local job_id = vim.fn.termopen(term_cmd, {
    on_exit = function()
      vim.schedule(function()
        M.close()
      end)
    end
  })
  
  -- Store job ID for potential task sending
  state.term_job_id = job_id
  
  -- Set up terminal keymaps
  M._setup_term_keymaps()
  
  -- Set active state
  state.active = true
  
  -- Enter terminal mode
  vim.cmd("startinsert")
  
  -- If we have a pending task, send it after a short delay
  if state.pending_task then
    vim.defer_fn(function()
      if state.term_job_id then
        vim.api.nvim_chan_send(state.term_job_id, state.pending_task .. "\n")
        state.pending_task = nil
      end
    end, 500) -- Wait 500ms for Claude to initialize
  end
end

-- Open API-based UI (fallback)
function M._open_api_ui()
  local global_state = require("claude-code").get_state()
  
  -- Get window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  -- Create history buffer and window
  state.history_buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(state.history_buf, "buftype", "nofile")
  api.nvim_buf_set_option(state.history_buf, "swapfile", false)
  api.nvim_buf_set_option(state.history_buf, "filetype", "markdown")
  
  state.history_win = api.nvim_open_win(state.history_buf, false, {
    relative = "editor",
    width = width,
    height = height - 3, -- Leave space for prompt
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Claude Code ",
    title_pos = "center",
  })
  
  -- Create prompt buffer and window
  state.prompt_buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(state.prompt_buf, "buftype", "nofile")
  api.nvim_buf_set_option(state.prompt_buf, "swapfile", false)
  api.nvim_buf_set_option(state.prompt_buf, "bufhidden", "wipe")
  
  state.prompt_win = api.nvim_open_win(state.prompt_buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    col = col,
    row = row + height - 2,
    style = "minimal",
    border = { "─", "─", "─", "─", "└", "┘", "│", "│" },
  })
  
  -- Set window options
  api.nvim_win_set_option(state.history_win, "number", false)
  api.nvim_win_set_option(state.history_win, "relativenumber", false)
  api.nvim_win_set_option(state.history_win, "cursorline", true)
  api.nvim_win_set_option(state.history_win, "wrap", true)
  api.nvim_win_set_option(state.history_win, "linebreak", true)
  
  api.nvim_win_set_option(state.prompt_win, "number", false)
  api.nvim_win_set_option(state.prompt_win, "relativenumber", false)
  
  -- Initialize prompt with prompt character
  api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {" ❯ "})
  
  -- Set up keymaps
  M._setup_keymaps()
  
  -- Render history
  M._render_history()
  
  -- Set active state
  state.active = true
  
  -- Focus prompt and position cursor after prompt
  api.nvim_set_current_win(state.prompt_win)
  api.nvim_win_set_cursor(state.prompt_win, {1, 3})
  vim.cmd("startinsert!")
end

-- Close the floating window
function M.close()
  -- Close terminal window
  if state.term_win and api.nvim_win_is_valid(state.term_win) then
    api.nvim_win_close(state.term_win, true)
  end
  
  -- Close API UI windows
  if state.prompt_win and api.nvim_win_is_valid(state.prompt_win) then
    api.nvim_win_close(state.prompt_win, true)
  end
  if state.history_win and api.nvim_win_is_valid(state.history_win) then
    api.nvim_win_close(state.history_win, true)
  end
  
  state.active = false
  state.term_win = nil
  state.term_buf = nil
  state.prompt_win = nil
  state.history_win = nil
  state.prompt_buf = nil
  state.history_buf = nil
end

-- Render the history
function M._render_history()
  if not state.history_buf then return end
  
  local global_state = require("claude-code").get_state()
  local lines = {}
  
  -- If no chat history, show welcome message
  if #global_state.chat_history == 0 then
    table.insert(lines, "# Welcome to Claude Code")
    table.insert(lines, "")
    table.insert(lines, "Type your message below and press Enter to send.")
    table.insert(lines, "")
    table.insert(lines, "**Quick tips:**")
    table.insert(lines, "- Press `Esc` to close this window")
    table.insert(lines, "- Press `q` in the history to close")
    table.insert(lines, "- Press `i` in the history to jump back to input")
    table.insert(lines, "")
    if config.use_local_claude and vim.fn.executable(vim.fn.expand("~/.claude/local/claude")) == 1 then
      table.insert(lines, "✓ Using local Claude Code CLI")
    else
      table.insert(lines, "⚡ Using Claude API directly")
    end
    table.insert(lines, "")
  end
  
  -- Context indicator
  if config.ui.show_context then
    local context = require("claude-code.context").get_current()
    if context and context.files and #context.files > 0 then
      table.insert(lines, "**Context:** " .. #context.files .. " files")
      for i, file in ipairs(context.files) do
        if i <= 3 then
          table.insert(lines, "  • " .. vim.fn.fnamemodify(file, ":~:."))
        end
      end
      if #context.files > 3 then
        table.insert(lines, "  • ...")
      end
      table.insert(lines, "")
      table.insert(lines, "---")
      table.insert(lines, "")
    end
  end
  
  -- Chat history
  for _, message in ipairs(global_state.chat_history) do
    if message.role == "user" then
      table.insert(lines, "### You")
      table.insert(lines, "")
      for line in message.content:gmatch("[^\n]+") do
        table.insert(lines, line)
      end
    else
      table.insert(lines, "### Claude")
      table.insert(lines, "")
      for line in message.content:gmatch("[^\n]+") do
        table.insert(lines, line)
      end
    end
    table.insert(lines, "")
  end
  
  -- Pending diffs indicator
  if #global_state.pending_diffs > 0 then
    table.insert(lines, "---")
    table.insert(lines, "")
    table.insert(lines, "**Pending Changes:** " .. #global_state.pending_diffs .. " files")
    table.insert(lines, "Press `" .. config.keymaps.accept_all .. "` to accept all")
    table.insert(lines, "")
  end
  
  -- Set lines
  api.nvim_buf_set_option(state.history_buf, "modifiable", true)
  api.nvim_buf_set_lines(state.history_buf, 0, -1, false, lines)
  api.nvim_buf_set_option(state.history_buf, "modifiable", false)
  
  -- Scroll to bottom
  if state.history_win and api.nvim_win_is_valid(state.history_win) then
    local line_count = api.nvim_buf_line_count(state.history_buf)
    api.nvim_win_set_cursor(state.history_win, {line_count, 0})
  end
end

-- Set up keymaps
function M._setup_keymaps()
  -- Prompt buffer keymaps
  local prompt_opts = { noremap = true, silent = true, buffer = state.prompt_buf }
  
  -- Submit on Enter
  vim.keymap.set("i", "<CR>", function() M._submit() end, prompt_opts)
  
  -- Close on Escape
  vim.keymap.set({"i", "n"}, "<Esc>", function() M.close() end, prompt_opts)
  
  -- History buffer keymaps
  local history_opts = { noremap = true, silent = true, buffer = state.history_buf }
  
  -- Close on q or Escape
  vim.keymap.set("n", "q", function() M.close() end, history_opts)
  vim.keymap.set("n", "<Esc>", function() M.close() end, history_opts)
  
  -- Switch to prompt
  vim.keymap.set("n", "i", function()
    api.nvim_set_current_win(state.prompt_win)
    vim.cmd("startinsert")
  end, history_opts)
  
  -- Accept/reject diffs
  vim.keymap.set("n", config.keymaps.accept_all, function()
    require("claude-code.diff").accept_all()
    M._render_history()
  end, history_opts)
  
  vim.keymap.set("n", config.keymaps.reject_all, function()
    require("claude-code.diff").reject_all()
    M._render_history()
  end, history_opts)
end

-- Submit the message
function M._submit()
  if not state.prompt_buf then return end
  
  -- Get the input text
  local lines = api.nvim_buf_get_lines(state.prompt_buf, 0, -1, false)
  local message = ""
  if #lines > 0 then
    message = lines[1]:gsub("^ ❯ ", "")
  end
  
  if message == "" then return end
  
  -- Clear prompt and reset with prompt character
  api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {" ❯ "})
  
  -- Add to chat history
  local global_state = require("claude-code").get_state()
  table.insert(global_state.chat_history, {
    role = "user",
    content = message
  })
  
  -- Update state
  require("claude-code").update_state({ chat_history = global_state.chat_history })
  
  -- Re-render to show user message
  M._render_history()
  
  -- Send to Claude (try local CLI first)
  M._send_message(message)
end

-- Send message to Claude
function M._send_message(message)
  local global_state = require("claude-code").get_state()
  
  -- Show loading indicator
  api.nvim_buf_set_option(state.history_buf, "modifiable", true)
  local lines = api.nvim_buf_get_lines(state.history_buf, 0, -1, false)
  table.insert(lines, "### Claude")
  table.insert(lines, "")
  table.insert(lines, "_Thinking..._")
  api.nvim_buf_set_lines(state.history_buf, 0, -1, false, lines)
  api.nvim_buf_set_option(state.history_buf, "modifiable", false)
  
  -- Check if local Claude Code CLI is available
  local has_local_claude = vim.fn.executable(vim.fn.expand("~/.claude/local/claude")) == 1
  
  if has_local_claude and config.use_local_claude ~= false then
    -- Use local Claude Code CLI
    M._send_via_cli(message)
  else
    -- Use API directly
    require("claude-code.api").send_message(message, function(response)
      M._handle_response(response)
    end)
  end
end

-- Send via local Claude Code CLI
function M._send_via_cli(message)
  local global_state = require("claude-code").get_state()
  local context = require("claude-code.context").get_current()
  
  -- Build command
  local cmd = {vim.fn.expand("~/.claude/local/claude")}
  
  -- Add context files
  for _, file in ipairs(context.files) do
    table.insert(cmd, file)
  end
  
  -- Add message
  table.insert(cmd, message)
  
  -- Run command asynchronously
  local output = {}
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        local response_text = table.concat(output, "\n")
        M._handle_response({
          content = response_text,
          changes = M._parse_cli_changes(response_text)
        })
      else
        M._handle_response({
          error = "Claude CLI failed with exit code " .. exit_code
        })
      end
    end
  })
end

-- Parse changes from CLI output
function M._parse_cli_changes(output)
  -- TODO: Parse code changes from CLI output format
  -- For now, return empty changes
  return {}
end

-- Handle response from Claude
function M._handle_response(response)
  local global_state = require("claude-code").get_state()
  
  if response.error then
    -- Replace loading with error
    api.nvim_buf_set_option(state.history_buf, "modifiable", true)
    local lines = api.nvim_buf_get_lines(state.history_buf, 0, -1, false)
    -- Find and replace the loading message
    for i = #lines, 1, -1 do
      if lines[i] == "_Thinking..._" then
        lines[i] = "**Error:** " .. response.error
        break
      end
    end
    api.nvim_buf_set_lines(state.history_buf, 0, -1, false, lines)
    api.nvim_buf_set_option(state.history_buf, "modifiable", false)
    return
  end
  
  -- Add response to chat history
  table.insert(global_state.chat_history, {
    role = "assistant",
    content = response.content
  })
  
  -- Process any code changes
  if response.changes and #response.changes > 0 then
    require("claude-code.diff").process_changes(response.changes)
  end
  
  -- Update state and re-render
  require("claude-code").update_state({ chat_history = global_state.chat_history })
  M._render_history()
end

-- Start a new chat
function M.new_chat()
  local global_state = require("claude-code").get_state()
  global_state.chat_history = {}
  require("claude-code").update_state({ chat_history = {} })
  
  M.open()
end

-- Start a new task
function M.new_task(task_description)
  M.new_chat()
  
  if task_description and task_description ~= "" then
    -- Pre-fill the prompt
    vim.schedule(function()
      if state.prompt_buf and api.nvim_buf_is_valid(state.prompt_buf) then
        api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {" ❯ " .. task_description})
        -- Position cursor at end
        api.nvim_win_set_cursor(state.prompt_win, {1, #task_description + 3})
      end
    end)
  end
end

-- Set up terminal keymaps
function M._setup_term_keymaps()
  local opts = { noremap = true, silent = true, buffer = state.term_buf }
  
  -- Close on Ctrl-C twice or Escape in normal mode
  vim.keymap.set("n", "<Esc>", function() M.close() end, opts)
  vim.keymap.set("n", "q", function() M.close() end, opts)
  
  -- Make Ctrl-C in terminal mode close after confirmation
  vim.keymap.set("t", "<C-c><C-c>", function() 
    vim.fn.jobstop(vim.b.terminal_job_id)
    M.close() 
  end, opts)
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