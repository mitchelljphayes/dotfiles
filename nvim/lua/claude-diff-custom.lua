-- Custom diff handler for Claude Code that replaces oil/non-essential windows
local M = {}

-- Helper function to find and use oil window
local function use_oil_window_for_diff()
  local windows = vim.api.nvim_list_wins()

  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    local win_config = vim.api.nvim_win_get_config(win)

    -- Skip floating windows and check for oil
    if not (win_config.relative and win_config.relative ~= "") then
      if filetype == "oil" or bufname:match("^oil://") then
        vim.api.nvim_set_current_win(win)
        return true
      end
    end
  end

  return false
end

function M.setup()
  -- Create an autocmd that runs before diff windows are created
  vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*.new",
    callback = function(args)
      -- Check if this is a Claude diff file
      if args.file:match("claudecode_diffs") then
        vim.schedule(function()
          -- Try to close extra windows if oil was replaced
          local wins = vim.api.nvim_list_wins()
          if #wins > 3 then -- More than claude, old file, and new file
            vim.notify("Detected extra windows after diff", vim.log.levels.DEBUG)
          end
        end)
      end
    end
  })

  -- Patch the diff module after it loads
  vim.defer_fn(function()
    local ok, diff_module = pcall(require, "claudecode.diff")
    if not ok then
      return
    end

    -- Store original functions
    local original_open_diff = diff_module.open_diff
    local original_native_diff = diff_module._open_native_diff

    -- Override _open_native_diff to position cursor in oil window first
    if original_native_diff then
      diff_module._open_native_diff = function(old_file_path, new_file_path, new_file_contents, tab_name)
        -- Try to use oil window
        local used_oil = use_oil_window_for_diff()
        if used_oil then
          vim.notify("Positioned in oil window for diff", vim.log.levels.INFO)
        end

        -- Call original function
        return original_native_diff(old_file_path, new_file_path, new_file_contents, tab_name)
      end

      vim.notify("Claude diff positioning helper installed", vim.log.levels.INFO)
    end
  end, 1000)
end

return M

