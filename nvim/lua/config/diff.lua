-- Configure Neovim's diff mode behavior
local M = {}

function M.setup()
  -- Set diff options
  vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "algorithm:patience",
    "linematch:60",
  }
  
  -- When entering diff mode, optimize window layout
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      
      -- Check if this looks like a Claude diff
      if bufname:match("%(proposed%)") or bufname:match("claudecode_diffs") then
        -- Delay to ensure diff is fully set up
        vim.defer_fn(function()
          local oil_wins = {}
          
          -- Find all oil windows
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
            local win_bufname = vim.api.nvim_buf_get_name(buf)
            
            if filetype == "oil" or win_bufname:match("^oil://") then
              table.insert(oil_wins, win)
            end
          end
          
          -- Close oil windows
          if #oil_wins > 0 then
            vim.notify(string.format("Closing %d oil window(s) for cleaner diff view", #oil_wins), vim.log.levels.INFO)
            for _, win in ipairs(oil_wins) do
              pcall(vim.api.nvim_win_close, win, false)
            end
            vim.cmd("wincmd =")
          end
        end, 300) -- Delay to ensure diff windows are created first
      end
    end,
  })
  
  -- Command to quickly toggle between diff and normal view
  vim.api.nvim_create_user_command("DiffToggle", function()
    if vim.wo.diff then
      vim.cmd("diffoff!")
      vim.cmd("Oil")
    else
      vim.cmd("diffthis")
    end
  end, { desc = "Toggle diff mode" })
end

return M