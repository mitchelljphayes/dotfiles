return {
  -- Claude Code - AI coding assistant integration for Neovim
  {
    dir = "/Users/mjp/Developer/nvim-plugins/claudecode.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Load inline diff override
      require("config.claude-inline-diff").setup()
      
      require("claudecode").setup({
        -- Terminal configuration
        terminal = {
          split_side = "right",          -- "left" or "right"
          split_width_percentage = 0.40, -- 40% of screen width
          provider = "snacks",           -- "snacks" or "native"
          auto_close = false,            -- Don't auto-close terminal
        },

        -- Diff configuration
        diff_opts = {
          -- Use unified/inline diff view
          diff_mode = "unified", -- "unified" for inline, "split" for side-by-side
          
          -- Disable split windows entirely
          vertical_split = false,
          horizontal_split = false,
          
          -- Open diffs in current buffer
          open_in_current_tab = true,
          replace_current_buffer = true,
          
          -- Unified diff display options
          unified_diff_format = true,
          show_line_numbers = true,
          context_lines = 3,
          
          -- Window sizing for diffs
          diff_window_options = {
            wrap = false,
            number = true,
            relativenumber = false,
            cursorline = true,
            signcolumn = "yes",
            foldcolumn = "0",
          },
          
          -- Highlight options
          highlight_changes = true,
          highlight_context = 3, -- lines of context around changes
          
          -- Add retry logic for diff operations
          retry_on_error = true,
          max_retries = 3,
        },
        
        -- Error handling
        error_handler = function(err)
          vim.notify("Claude Code error: " .. tostring(err), vim.log.levels.WARN)
        end,

        -- Keymaps
        keymaps = {
          toggle = "<leader>cc",
          accept_all = "<leader>ca",
          reject_all = "<leader>cr",
          next_diff = "]c",
          prev_diff = "[c",
        },

        -- Auto-save before running commands
        auto_save = true,
        
        -- Ensure buffers are synced before operations
        sync_before_edit = true,
      })

      -- Set up styling for Claude Code terminals and keep them on the left
      vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
        pattern = "*",
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          -- Only apply to actual Claude Code terminals
          if bufname:match("term://") and bufname:match("claude") then
            vim.cmd([[
              setlocal winhighlight=
              setlocal fillchars=eob:\
              setlocal nonumber norelativenumber
              setlocal signcolumn=no
              setlocal foldcolumn=0
              setlocal winbar=
              setlocal statusline=
            ]])
          end
        end,
      })

      -- Keep Claude Code on the left side
      vim.api.nvim_create_autocmd({ "WinNew", "WinEnter", "TermOpen" }, {
        callback = function()
          vim.defer_fn(function()
            -- Find Claude terminal window
            local claude_win = nil
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local buf_name = vim.api.nvim_buf_get_name(buf)
              if buf_name:match("term://") and buf_name:match("claude") then
                claude_win = win
                break
              end
            end

            if claude_win then
              -- Check if Claude is not already leftmost
              local claude_pos = vim.api.nvim_win_get_position(claude_win)[2]
              local leftmost = true

              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local pos = vim.api.nvim_win_get_position(win)[2]
                if pos < claude_pos then
                  leftmost = false
                  break
                end
              end

              -- Move Claude to left if needed
              if not leftmost then
                local current = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(claude_win)
                vim.cmd("wincmd H")
                -- Set width to 40% of screen
                local total_width = vim.o.columns
                local claude_width = math.floor(total_width * 0.4)
                vim.api.nvim_win_set_width(claude_win, claude_width)
                vim.api.nvim_set_current_win(current)
              end
            end
          end, 100)
        end,
      })

      -- Also handle when ClaudeCode command is run
      vim.api.nvim_create_user_command("ClaudeCodeLeft", function()
        -- Find and move Claude to left
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name:match("term://") and buf_name:match("claude") then
            vim.api.nvim_set_current_win(win)
            vim.cmd("wincmd H")
            -- Set width to 40% of screen
            local total_width = vim.o.columns
            local claude_width = math.floor(total_width * 0.4)
            vim.api.nvim_win_set_width(win, claude_width)
            break
          end
        end
      end, { desc = "Move Claude Code to left side" })

      -- Link terminal colors to editor colors
      vim.cmd([[
        highlight! link TermNormal Normal
        highlight! link TermNormalNC Normal
      ]])
      
      -- Override diff highlights to use OneDark colors instead of default blue
      vim.cmd([[
        highlight! ClaudeCodeDiffAdd guifg=#98c379 ctermfg=2
        highlight! ClaudeCodeDiffDelete guifg=#e06c75 ctermfg=1  
        highlight! ClaudeCodeDiffChange guifg=#e5c07b ctermfg=3
        highlight! link DiffAdd ClaudeCodeDiffAdd
        highlight! link DiffDelete ClaudeCodeDiffDelete
        highlight! link DiffChange ClaudeCodeDiffChange
      ]])
      
      -- Visual focus indicators
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("ClaudeCodeFocusIndicator", { clear = true }),
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("term://") and bufname:match("claude") then
            -- In Claude terminal - show focus indicator
            vim.opt_local.cursorline = true
            -- Remove custom window highlight to use terminal defaults
            vim.opt_local.winhl = ""
          end
        end,
        desc = "Highlight focused Claude terminal",
      })
      
      vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        group = vim.api.nvim_create_augroup("ClaudeCodeUnfocusIndicator", { clear = true }),
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("term://") and bufname:match("claude") then
            -- Leaving Claude terminal - remove focus indicator
            vim.opt_local.cursorline = false
            -- Remove custom window highlight to use terminal defaults
            vim.opt_local.winhl = ""
          end
        end,
        desc = "Remove highlight from unfocused Claude terminal",
      })
      
      -- Remove custom highlight groups to let terminal use its own colors
      -- vim.cmd([[
      --   highlight ClaudeTerminalFocused guibg=#1e2127 ctermbg=235
      --   highlight ClaudeTerminalUnfocused guibg=#181a1f ctermbg=234
      -- ]])
      
      -- Command to reset Claude Code state when errors occur
      vim.api.nvim_create_user_command("ClaudeCodeReset", function()
        -- Close all diff windows
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:match("claudecode_diffs") then
            vim.api.nvim_win_close(win, true)
          end
        end
        vim.notify("Claude Code diff state reset", vim.log.levels.INFO)
      end, { desc = "Reset Claude Code diff state after errors" })
      
      -- Command to view diffs in unified format
      vim.api.nvim_create_user_command("ClaudeCodeUnifiedDiff", function()
        -- Find the most recent Claude diff files
        local old_file = vim.fn.glob("/tmp/claudecode_diffs/**/*.old", false, true)[1]
        local new_file = vim.fn.glob("/tmp/claudecode_diffs/**/*.new", false, true)[1]
        
        if old_file and new_file then
          -- Create a unified diff view
          vim.cmd("tabnew")
          vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
          vim.cmd("setlocal filetype=diff")
          
          -- Run diff command and capture output
          local diff_output = vim.fn.system(string.format("diff -u %s %s", old_file, new_file))
          
          -- Set buffer content
          vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(diff_output, "\n"))
          
          -- Set up highlighting
          vim.cmd([[
            syntax match diffAdded "^+.*" containedin=ALL
            syntax match diffRemoved "^-.*" containedin=ALL
            syntax match diffLine "^@.*" containedin=ALL
            
            highlight diffAdded guifg=#98c379 ctermfg=2
            highlight diffRemoved guifg=#e06c75 ctermfg=1
            highlight diffLine guifg=#61afef ctermfg=4
          ]])
        else
          vim.notify("No Claude Code diff files found", vim.log.levels.WARN)
        end
      end, { desc = "View Claude Code changes in unified diff format" })
    end,
    keys = {
      -- Toggle and navigation
      { "<leader>cc", "<cmd>ClaudeCode<cr>",             desc = "Toggle Claude Code" },
      { "<leader>cf", "<cmd>ClaudeCodeFocusToggle<cr>",  desc = "Smart focus toggle (focus/hide)" },
      { "<leader>ct", "<cmd>ClaudeCodeSimpleToggle<cr>", desc = "Simple toggle (show/hide)" },
      { "<M-c>",      "<cmd>ClaudeCodeJump<cr>",         desc = "Jump to Claude terminal" },
      { "<M-e>",      "<cmd>ClaudeCodeReturn<cr>",       desc = "Return to editor from Claude" },
      
      -- Diff management
      { "<leader>ca", desc = "Accept all Claude changes" },
      { "<leader>cr", desc = "Reject all Claude changes" },
      { "<leader>cu", "<cmd>ClaudeCodeUnifiedDiff<cr>",  desc = "View unified diff" },
      { "]c",         desc = "Next Claude diff" },
      { "[c",         desc = "Previous Claude diff" },
      
      -- Terminal mode keymaps
      { "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
      { "<leader><Esc>", function()
          -- Hide Claude and return to editor
          local focus = require("claudecode.focus")
          if focus.is_in_claude_terminal() then
            vim.cmd("ClaudeCodeReturn")
          end
        end,
        mode = "t",
        desc = "Hide Claude and return to editor"
      },
    },
  },
}

