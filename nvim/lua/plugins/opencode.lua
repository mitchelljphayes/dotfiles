return {
  -- OpenCode terminal integration - Alternative to Claude Code
  {
    "opencode-integration",
    dir = vim.fn.stdpath("config") .. "/lua/opencode-integration",
    lazy = false,
    priority = 1000,
    config = function()
      -- Create the integration directory if it doesn't exist
      local integration_dir = vim.fn.stdpath("config") .. "/lua/opencode-integration"
      vim.fn.mkdir(integration_dir, "p")

      -- OpenCode terminal management
      local opencode_term = nil
      local opencode_buf = nil

      local function toggle_opencode_terminal()
        if opencode_term and vim.api.nvim_win_is_valid(opencode_term) then
          -- Close existing terminal
          vim.api.nvim_win_close(opencode_term, true)
          opencode_term = nil
          return
        end

        -- Create new terminal split on the left
        vim.cmd("topleft vsplit")
        local win = vim.api.nvim_get_current_win()
        
        -- Set width to 40% of screen
        local total_width = vim.o.columns
        local opencode_width = math.floor(total_width * 0.4)
        vim.api.nvim_win_set_width(win, opencode_width)
        
        -- Start opencode terminal with full path
        local opencode_path = vim.fn.exepath("opencode")
        if opencode_path == "" then
          vim.notify("OpenCode not found in PATH", vim.log.levels.ERROR)
          vim.api.nvim_win_close(win, true)
          return
        end
        
        -- Start opencode with one-dark theme
        vim.cmd("terminal " .. opencode_path .. " --theme one-dark")
        opencode_term = win
        opencode_buf = vim.api.nvim_get_current_buf()
        
        -- Configure terminal buffer
        vim.bo[opencode_buf].buflisted = false
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].foldcolumn = "0"
        vim.wo[win].winbar = ""
        vim.wo[win].statusline = " OpenCode "
        
        -- Set terminal colors to match one-dark theme
        vim.api.nvim_buf_set_option(opencode_buf, 'termguicolors', true)
        
        -- Apply one-dark color scheme to terminal
        vim.cmd([[
          highlight! TermCursor guifg=#282c34 guibg=#61afef
          highlight! TermCursorNC guifg=#282c34 guibg=#5c6370
        ]])
        
        -- Enter insert mode in terminal
        vim.cmd("startinsert")
      end

      local function launch_opencode()
        -- Check if opencode exists
        local opencode_path = vim.fn.exepath("opencode")
        if opencode_path == "" then
          vim.notify("OpenCode not found in PATH", vim.log.levels.ERROR)
          return
        end
        
        -- Launch opencode in background
        local job_id = vim.fn.jobstart(opencode_path, {
          detach = true,
          on_exit = function(_, code)
            if code ~= 0 then
              vim.notify("OpenCode exited with code: " .. code, vim.log.levels.WARN)
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 0 then
              vim.notify("OpenCode error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
            end
          end,
        })
        
        if job_id > 0 then
          vim.notify("OpenCode launched", vim.log.levels.INFO)
        else
          vim.notify("Failed to launch OpenCode", vim.log.levels.ERROR)
        end
      end

      local function opencode_in_current_dir()
        -- Check if opencode exists
        local opencode_path = vim.fn.exepath("opencode")
        if opencode_path == "" then
          vim.notify("OpenCode not found in PATH", vim.log.levels.ERROR)
          return
        end
        
        -- Launch opencode in current file's directory
        local current_file = vim.fn.expand("%:p")
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        
        local job_id = vim.fn.jobstart(opencode_path, {
          cwd = current_dir,
          detach = true,
          on_exit = function(_, code)
            if code ~= 0 then
              vim.notify("OpenCode exited with code: " .. code, vim.log.levels.WARN)
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 0 then
              vim.notify("OpenCode error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
            end
          end,
        })
        
        if job_id > 0 then
          vim.notify("OpenCode launched in " .. current_dir, vim.log.levels.INFO)
        else
          vim.notify("Failed to launch OpenCode in " .. current_dir, vim.log.levels.ERROR)
        end
      end

      -- Commands
      vim.api.nvim_create_user_command("OpenCodeTerminal", toggle_opencode_terminal, {
        desc = "Toggle OpenCode terminal split"
      })

      vim.api.nvim_create_user_command("OpenCodeLaunch", launch_opencode, {
        desc = "Launch OpenCode in background"
      })

      vim.api.nvim_create_user_command("OpenCodeHere", opencode_in_current_dir, {
        desc = "Launch OpenCode in current file's directory"
      })

      -- Auto-styling for opencode terminals
      vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
        pattern = "*",
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("term://") and bufname:match("opencode") then
            -- Terminal UI settings
            vim.opt_local.winhighlight = "Normal:Normal,NormalNC:Normal"
            vim.opt_local.fillchars = "eob: "
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.foldcolumn = "0"
            
            -- Ensure terminal uses GUI colors
            vim.opt_local.termguicolors = true
            
            -- Set one-dark background color
            vim.cmd([[
              setlocal winhl=Normal:NormalFloat
              highlight NormalFloat guibg=#282c34
            ]])
          end
        end,
      })

      -- Link terminal colors to editor colors
      vim.cmd([[
        highlight! link TermNormal Normal
        highlight! link TermNormalNC Normal
      ]])
    end,
    keys = {
      { "<leader>oc", "<cmd>OpenCodeTerminal<cr>", desc = "Toggle OpenCode Terminal" },
      { "<leader>ol", "<cmd>OpenCodeLaunch<cr>",   desc = "Launch OpenCode" },
      { "<leader>oh", "<cmd>OpenCodeHere<cr>",     desc = "Launch OpenCode Here" },
    },
  },
}