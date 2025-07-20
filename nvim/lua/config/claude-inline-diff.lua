-- Override Claude Code's diff behavior to show inline/unified diffs
local M = {}

-- Function to convert Claude's side-by-side diff to unified format
function M.setup()
  -- Override the vsplit command when in Claude diff context
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.old,*.new",
    callback = function(args)
      local bufname = vim.api.nvim_buf_get_name(args.buf)
      
      -- Check if this is a Claude Code diff
      if bufname:match("claudecode_diffs") then
        -- Schedule to run after Claude's diff setup
        vim.schedule(function()
          -- Get the current window and buffer info
          local old_win = nil
          local new_win = nil
          local old_buf = nil
          local new_buf = nil
          
          -- Find the old and new diff windows
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            
            if name:match("%.old$") then
              old_win = win
              old_buf = buf
            elseif name:match("%.new$") then
              new_win = win
              new_buf = buf
            end
          end
          
          -- If we found both windows, convert to unified view
          if old_win and new_win and old_buf and new_buf then
            -- Get the content from both buffers
            local old_lines = vim.api.nvim_buf_get_lines(old_buf, 0, -1, false)
            local new_lines = vim.api.nvim_buf_get_lines(new_buf, 0, -1, false)
            
            -- Close the old window
            vim.api.nvim_win_close(old_win, true)
            
            -- Create unified diff in the new window
            vim.api.nvim_set_current_win(new_win)
            
            -- Generate unified diff
            local diff_lines = {}
            local old_file = vim.fn.tempname()
            local new_file = vim.fn.tempname()
            
            -- Write content to temp files
            vim.fn.writefile(old_lines, old_file)
            vim.fn.writefile(new_lines, new_file)
            
            -- Get the original filename
            local orig_name = vim.api.nvim_buf_get_name(new_buf):match("([^/]+)%.new$") or "file"
            
            -- Run diff command
            local diff_cmd = string.format("diff -u %s %s", vim.fn.shellescape(old_file), vim.fn.shellescape(new_file))
            local diff_output = vim.fn.system(diff_cmd)
            
            -- Clean up temp files
            vim.fn.delete(old_file)
            vim.fn.delete(new_file)
            
            -- Process diff output
            local lines = vim.split(diff_output, "\n")
            
            -- Fix the header to show the actual filename
            if #lines > 2 then
              lines[1] = "--- " .. orig_name .. " (original)"
              lines[2] = "+++ " .. orig_name .. " (modified)"
            end
            
            -- Create a new buffer for the unified diff
            local diff_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(new_win, diff_buf)
            
            -- Set buffer options
            vim.api.nvim_buf_set_option(diff_buf, 'buftype', 'nofile')
            vim.api.nvim_buf_set_option(diff_buf, 'bufhidden', 'wipe')
            vim.api.nvim_buf_set_option(diff_buf, 'swapfile', false)
            vim.api.nvim_buf_set_option(diff_buf, 'filetype', 'diff')
            
            -- Set the diff content
            vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, lines)
            
            -- Set buffer name
            vim.api.nvim_buf_set_name(diff_buf, "Claude Code Diff: " .. orig_name)
            
            -- Add keymaps for accepting/rejecting
            vim.keymap.set('n', '<leader>ca', function()
              -- Trigger Claude's accept action
              vim.cmd('ClaudeCodeAcceptAll')
            end, { buffer = diff_buf, desc = "Accept all changes" })
            
            vim.keymap.set('n', '<leader>cr', function()
              -- Trigger Claude's reject action
              vim.cmd('ClaudeCodeRejectAll')
            end, { buffer = diff_buf, desc = "Reject all changes" })
            
            -- Notify user
            vim.notify("Converted to unified diff view. Use <leader>ca to accept, <leader>cr to reject.", vim.log.levels.INFO)
          end
        end)
      end
    end
  })
end

return M