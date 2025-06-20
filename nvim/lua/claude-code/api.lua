-- API module for Claude Code
local M = {}
local curl = require("plenary.curl")

local config = {}

function M.setup(cfg)
  config = cfg
end

-- Send a message to Claude
function M.send_message(message, callback)
  local claude_config = require("claude-code").config
  local state = require("claude-code").get_state()
  
  -- Build the context
  local context = require("claude-code.context").get_current()
  
  -- Build messages array
  local messages = {}
  
  -- Add chat history
  for _, msg in ipairs(state.chat_history) do
    table.insert(messages, {
      role = msg.role,
      content = msg.content
    })
  end
  
  -- Add current message
  table.insert(messages, {
    role = "user",
    content = message
  })
  
  -- Build system prompt with context
  local system_prompt = claude_config.system_prompt
  if #context.files > 0 then
    system_prompt = system_prompt .. "\n\nCurrent context files:\n"
    for _, file in ipairs(context.files) do
      local content = vim.fn.readfile(file)
      system_prompt = system_prompt .. "\n--- " .. file .. " ---\n"
      system_prompt = system_prompt .. table.concat(content, "\n")
    end
  end
  
  -- Make API request
  local response = curl.post("https://api.anthropic.com/v1/messages", {
    headers = {
      ["x-api-key"] = claude_config.api_key,
      ["anthropic-version"] = "2023-06-01",
      ["content-type"] = "application/json",
    },
    body = vim.fn.json_encode({
      model = claude_config.model,
      max_tokens = claude_config.max_tokens,
      temperature = claude_config.temperature,
      system = system_prompt,
      messages = messages,
    }),
    callback = function(response)
      if response.status ~= 200 then
        callback({ error = "API error: " .. response.status })
        return
      end
      
      local ok, data = pcall(vim.fn.json_decode, response.body)
      if not ok then
        callback({ error = "Failed to parse response" })
        return
      end
      
      -- Extract content and parse for code changes
      local content = data.content[1].text
      local changes = M._parse_code_changes(content)
      
      callback({
        content = content,
        changes = changes,
      })
    end,
  })
end

-- Parse code changes from Claude's response
function M._parse_code_changes(content)
  local changes = {}
  
  -- Look for code blocks with file indicators
  local current_file = nil
  local current_content = {}
  local in_code_block = false
  
  for line in content:gmatch("[^\n]+") do
    -- Check for file indicator
    local file_match = line:match("^```(%S+)%s+(.+)$") or line:match("^File: (.+)$")
    if file_match then
      if current_file and #current_content > 0 then
        table.insert(changes, {
          file = current_file,
          content = table.concat(current_content, "\n"),
        })
      end
      current_file = file_match
      current_content = {}
      in_code_block = false
    elseif line:match("^```") then
      if in_code_block and current_file and #current_content > 0 then
        table.insert(changes, {
          file = current_file,
          content = table.concat(current_content, "\n"),
        })
        current_file = nil
        current_content = {}
      end
      in_code_block = not in_code_block
    elseif in_code_block and current_file then
      table.insert(current_content, line)
    end
  end
  
  -- Handle last file
  if current_file and #current_content > 0 then
    table.insert(changes, {
      file = current_file,
      content = table.concat(current_content, "\n"),
    })
  end
  
  return changes
end

return M