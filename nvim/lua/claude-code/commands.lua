-- Commands setup for Claude Code
local M = {}

function M.setup(config)
  -- Quick commands for common tasks
  vim.api.nvim_create_user_command("ClaudeExplain", function()
    local lines = M.get_visual_selection()
    if #lines == 0 then
      vim.notify("No selection", vim.log.levels.WARN)
      return
    end
    
    local code = table.concat(lines, "\n")
    local prompt = "Please explain this code:\n\n```\n" .. code .. "\n```"
    
    require("claude-code.ui").new_task(prompt)
  end, { range = true, desc = "Explain selected code" })
  
  vim.api.nvim_create_user_command("ClaudeRefactor", function()
    local lines = M.get_visual_selection()
    if #lines == 0 then
      vim.notify("No selection", vim.log.levels.WARN)
      return
    end
    
    local code = table.concat(lines, "\n")
    local prompt = "Please refactor this code to be cleaner and more maintainable:\n\n```\n" .. code .. "\n```"
    
    require("claude-code.ui").new_task(prompt)
  end, { range = true, desc = "Refactor selected code" })
  
  vim.api.nvim_create_user_command("ClaudeFix", function()
    -- Get diagnostics for current buffer
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify("No diagnostics found", vim.log.levels.INFO)
      return
    end
    
    -- Get current buffer content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, "\n")
    
    -- Build prompt with diagnostics
    local prompt = "Please fix the following issues in this code:\n\n"
    for _, diag in ipairs(diagnostics) do
      prompt = prompt .. string.format("- Line %d: %s\n", diag.lnum + 1, diag.message)
    end
    
    prompt = prompt .. "\n```\n" .. content .. "\n```"
    
    require("claude-code.ui").new_task(prompt)
  end, { desc = "Fix diagnostics in current file" })
  
  vim.api.nvim_create_user_command("ClaudeTest", function()
    local filepath = vim.fn.expand("%:p")
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    
    local prompt = string.format(
      "Please generate comprehensive tests for this code:\n\nFile: %s\n\n```\n%s\n```",
      filepath, content
    )
    
    require("claude-code.ui").new_task(prompt)
  end, { desc = "Generate tests for current file" })
  
  vim.api.nvim_create_user_command("ClaudeDoc", function()
    local lines = M.get_visual_selection()
    if #lines == 0 then
      -- Use whole file if no selection
      lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end
    
    local code = table.concat(lines, "\n")
    local prompt = "Please add comprehensive documentation to this code:\n\n```\n" .. code .. "\n```"
    
    require("claude-code.ui").new_task(prompt)
  end, { range = true, desc = "Generate documentation" })
end

-- Get visual selection
function M.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  
  if start_pos[2] == 0 or end_pos[2] == 0 then
    return {}
  end
  
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  
  return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
end

return M