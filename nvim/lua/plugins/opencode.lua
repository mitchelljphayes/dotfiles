---@diagnostic disable: undefined-global
return {
  -- OpenCode terminal integration - Full-featured nvim integration
  {
    "opencode-integration",
    dir = vim.fn.stdpath("config") .. "/lua/opencode-integration",
    lazy = false,
    priority = 1000,
    config = function()
      -- Create the integration directory if it doesn't exist
      local integration_dir = vim.fn.stdpath("config") .. "/lua/opencode-integration"
      vim.fn.mkdir(integration_dir, "p")

      -- State management
      local state = {
        term_win = nil,
        term_buf = nil,
        term_job = nil,
        position = "right", -- left, right, bottom, float
        width_percent = 0.4,
        height_percent = 0.3,
        last_position = "right",
        file_watchers = {},
        watched_buffers = {},
      }

      -- Save/load session state
      local session_file = vim.fn.stdpath("data") .. "/opencode_session.json"

      local function save_session()
        local session_data = {
          position = state.position,
          width_percent = state.width_percent,
          height_percent = state.height_percent,
        }
        local file = io.open(session_file, "w")
        if file then
          file:write(vim.fn.json_encode(session_data))
          file:close()
        end
      end

      local function load_session()
        local file = io.open(session_file, "r")
        if file then
          local content = file:read("*all")
          file:close()
          local ok, data = pcall(vim.fn.json_decode, content)
          if ok and data then
            state.position = data.position or "left"
            state.width_percent = data.width_percent or 0.4
            state.height_percent = data.height_percent or 0.3
          end
        end
      end

      -- Load session on startup
      load_session()

      -- ============================================
      -- FILE WATCHING / AUTO-RELOAD
      -- ============================================
      local function setup_file_watcher(bufnr)
        if state.watched_buffers[bufnr] then
          return
        end

        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if filepath == "" then
          return
        end

        -- Use libuv file watcher
        local handle = vim.loop.new_fs_event()
        if not handle then
          return
        end

        local function on_change(err, _, _)
          if err then
            return
          end

          -- Schedule the reload on the main thread
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              handle:stop()
              state.file_watchers[bufnr] = nil
              state.watched_buffers[bufnr] = nil
              return
            end

            -- Check if buffer has unsaved changes
            if vim.bo[bufnr].modified then
              vim.notify("File changed on disk: " .. vim.fn.fnamemodify(filepath, ":t") .. " (buffer has unsaved changes)", vim.log.levels.WARN)
              return
            end

            -- Reload the buffer
            -- Find a window showing this buffer and reload
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == bufnr then
                vim.api.nvim_win_call(win, function()
                  vim.cmd("checktime")
                end)
                break
              end
            end

            -- If not visible, just checktime on the buffer
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd("checktime")
            end)
          end)
        end

        -- Start watching
        local ok = pcall(function()
          handle:start(filepath, {}, on_change)
        end)

        if ok then
          state.file_watchers[bufnr] = handle
          state.watched_buffers[bufnr] = true
        end
      end

      local function stop_file_watcher(bufnr)
        local handle = state.file_watchers[bufnr]
        if handle then
          handle:stop()
          state.file_watchers[bufnr] = nil
          state.watched_buffers[bufnr] = nil
        end
      end

      -- Auto-setup watchers for opened buffers
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        callback = function(args)
          setup_file_watcher(args.buf)
        end,
        desc = "Setup file watcher for OpenCode auto-reload",
      })

      vim.api.nvim_create_autocmd("BufDelete", {
        callback = function(args)
          stop_file_watcher(args.buf)
        end,
        desc = "Cleanup file watcher on buffer delete",
      })

      -- Also enable autoread
      vim.o.autoread = true
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        callback = function()
          if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
          end
        end,
        desc = "Auto-reload files changed outside nvim",
      })

      -- ============================================
      -- TERMINAL WINDOW MANAGEMENT
      -- ============================================
      local function get_opencode_cmd()
        local opencode_path = vim.fn.exepath("opencode")
        if opencode_path == "" then
          vim.notify("OpenCode not found in PATH", vim.log.levels.ERROR)
          return nil
        end
        return opencode_path
      end

      local function configure_terminal_window(win, buf)
        vim.bo[buf].buflisted = false
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].foldcolumn = "0"
        vim.wo[win].winbar = ""
        vim.wo[win].statusline = " OpenCode "
        vim.wo[win].winfixwidth = true
        vim.wo[win].winfixheight = true

        -- Terminal colors
        vim.cmd([[
          highlight! TermCursor guifg=#282c34 guibg=#61afef
          highlight! TermCursorNC guifg=#282c34 guibg=#5c6370
        ]])
      end

      local function close_opencode_terminal()
        if state.term_win and vim.api.nvim_win_is_valid(state.term_win) then
          vim.api.nvim_win_close(state.term_win, true)
        end
        state.term_win = nil
        state.term_buf = nil
        state.term_job = nil
      end

      local function open_terminal_left()
        local cmd = get_opencode_cmd()
        if not cmd then return end

        vim.cmd("topleft vsplit")
        local win = vim.api.nvim_get_current_win()
        local width = math.floor(vim.o.columns * state.width_percent)
        vim.api.nvim_win_set_width(win, width)

        vim.cmd("terminal " .. cmd)
        state.term_win = win
        state.term_buf = vim.api.nvim_get_current_buf()
        state.position = "left"
        configure_terminal_window(win, state.term_buf)
        vim.cmd("startinsert")
        save_session()
      end

      local function open_terminal_right()
        local cmd = get_opencode_cmd()
        if not cmd then return end

        vim.cmd("botright vsplit")
        local win = vim.api.nvim_get_current_win()
        local width = math.floor(vim.o.columns * state.width_percent)
        vim.api.nvim_win_set_width(win, width)

        vim.cmd("terminal " .. cmd)
        state.term_win = win
        state.term_buf = vim.api.nvim_get_current_buf()
        state.position = "right"
        configure_terminal_window(win, state.term_buf)
        vim.cmd("startinsert")
        save_session()
      end

      local function open_terminal_bottom()
        local cmd = get_opencode_cmd()
        if not cmd then return end

        vim.cmd("botright split")
        local win = vim.api.nvim_get_current_win()
        local height = math.floor(vim.o.lines * state.height_percent)
        vim.api.nvim_win_set_height(win, height)

        vim.cmd("terminal " .. cmd)
        state.term_win = win
        state.term_buf = vim.api.nvim_get_current_buf()
        state.position = "bottom"
        configure_terminal_window(win, state.term_buf)
        vim.cmd("startinsert")
        save_session()
      end

      local function open_terminal_float()
        local cmd = get_opencode_cmd()
        if not cmd then return end

        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = col,
          row = row,
          style = "minimal",
          border = "rounded",
          title = " OpenCode ",
          title_pos = "center",
        })

        vim.cmd("terminal " .. cmd)
        state.term_win = win
        state.term_buf = vim.api.nvim_get_current_buf()
        state.position = "float"
        configure_terminal_window(win, state.term_buf)
        vim.cmd("startinsert")
        save_session()
      end

      local function toggle_opencode_terminal()
        if state.term_win and vim.api.nvim_win_is_valid(state.term_win) then
          close_opencode_terminal()
          return
        end

        -- Open based on last/current position
        local pos = state.position or "left"
        if pos == "left" then
          open_terminal_left()
        elseif pos == "right" then
          open_terminal_right()
        elseif pos == "bottom" then
          open_terminal_bottom()
        elseif pos == "float" then
          open_terminal_float()
        else
          open_terminal_left()
        end
      end

      local function focus_opencode()
        if state.term_win and vim.api.nvim_win_is_valid(state.term_win) then
          vim.api.nvim_set_current_win(state.term_win)
          vim.cmd("startinsert")
        else
          toggle_opencode_terminal()
        end
      end

      -- ============================================
      -- SEND CONTEXT TO OPENCODE
      -- ============================================
      local function send_file_path()
        local filepath = vim.fn.expand("%:p")
        if filepath == "" then
          vim.notify("No file in current buffer", vim.log.levels.WARN)
          return
        end

        -- Copy to clipboard and notify
        vim.fn.setreg("+", filepath)
        vim.notify("Copied to clipboard: " .. filepath, vim.log.levels.INFO)

        -- Focus OpenCode terminal
        focus_opencode()
      end

      local function send_selection()
        -- Get visual selection
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local lines = vim.fn.getline(start_pos[2], end_pos[2])

        if #lines == 0 then
          vim.notify("No selection", vim.log.levels.WARN)
          return
        end

        -- Handle partial line selection
        if #lines == 1 then
          lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
        else
          lines[1] = string.sub(lines[1], start_pos[3])
          lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
        end

        local text = table.concat(lines, "\n")
        vim.fn.setreg("+", text)
        vim.notify("Copied selection to clipboard (" .. #lines .. " lines)", vim.log.levels.INFO)

        -- Focus OpenCode terminal
        focus_opencode()
      end

      local function send_buffer_content()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, "\n")
        vim.fn.setreg("+", content)
        vim.notify("Copied buffer content to clipboard", vim.log.levels.INFO)
        focus_opencode()
      end

      local function send_diagnostics()
        local bufnr = vim.api.nvim_get_current_buf()
        local diagnostics = vim.diagnostic.get(bufnr)

        if #diagnostics == 0 then
          vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
          return
        end

        local filename = vim.fn.expand("%:t")
        local lines = { "Diagnostics for " .. filename .. ":", "" }

        for _, d in ipairs(diagnostics) do
          local severity = vim.diagnostic.severity[d.severity] or "UNKNOWN"
          table.insert(lines, string.format(
            "%s:%d:%d [%s] %s",
            filename,
            d.lnum + 1,
            d.col + 1,
            severity,
            d.message
          ))
        end

        local text = table.concat(lines, "\n")
        vim.fn.setreg("+", text)
        vim.notify("Copied " .. #diagnostics .. " diagnostics to clipboard", vim.log.levels.INFO)
        focus_opencode()
      end

      local function send_git_diff()
        local filepath = vim.fn.expand("%:p")
        local diff_output

        if filepath ~= "" then
          diff_output = vim.fn.system("git diff -- " .. vim.fn.shellescape(filepath))
        else
          diff_output = vim.fn.system("git diff")
        end

        if vim.v.shell_error ~= 0 or diff_output == "" then
          vim.notify("No git diff available", vim.log.levels.INFO)
          return
        end

        vim.fn.setreg("+", diff_output)
        vim.notify("Copied git diff to clipboard", vim.log.levels.INFO)
        focus_opencode()
      end

      local function send_git_status()
        local status_output = vim.fn.system("git status --short")

        if vim.v.shell_error ~= 0 or status_output == "" then
          vim.notify("No git status available", vim.log.levels.INFO)
          return
        end

        vim.fn.setreg("+", status_output)
        vim.notify("Copied git status to clipboard", vim.log.levels.INFO)
        focus_opencode()
      end

      local function send_project_context()
        local cwd = vim.fn.getcwd()
        local context_lines = {
          "Project Context:",
          "================",
          "",
          "Working Directory: " .. cwd,
          "Current File: " .. vim.fn.expand("%:p"),
          "Filetype: " .. vim.bo.filetype,
          "",
        }

        -- Add git branch if available
        local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
        if branch ~= "" then
          table.insert(context_lines, "Git Branch: " .. branch)
        end

        -- Add recent git commits
        local commits = vim.fn.system("git log --oneline -5 2>/dev/null")
        if commits ~= "" then
          table.insert(context_lines, "")
          table.insert(context_lines, "Recent Commits:")
          for line in commits:gmatch("[^\n]+") do
            table.insert(context_lines, "  " .. line)
          end
        end

        -- Add LSP info
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients > 0 then
          table.insert(context_lines, "")
          table.insert(context_lines, "Active LSP Servers:")
          for _, client in ipairs(clients) do
            table.insert(context_lines, "  - " .. client.name)
          end
        end

        -- Add current file diagnostics summary
        local diagnostics = vim.diagnostic.get(0)
        if #diagnostics > 0 then
          local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }
          for _, d in ipairs(diagnostics) do
            local sev = vim.diagnostic.severity[d.severity]
            if counts[sev] then
              counts[sev] = counts[sev] + 1
            end
          end
          table.insert(context_lines, "")
          table.insert(context_lines, string.format(
            "Diagnostics: %d errors, %d warnings, %d info, %d hints",
            counts.ERROR, counts.WARN, counts.INFO, counts.HINT
          ))
        end

        local context = table.concat(context_lines, "\n")
        vim.fn.setreg("+", context)
        vim.notify("Copied project context to clipboard", vim.log.levels.INFO)
        focus_opencode()
      end

      -- ============================================
      -- COMMANDS
      -- ============================================
      vim.api.nvim_create_user_command("OpenCode", toggle_opencode_terminal, {
        desc = "Toggle OpenCode terminal"
      })

      vim.api.nvim_create_user_command("OpenCodeLeft", function()
        close_opencode_terminal()
        open_terminal_left()
      end, { desc = "Open OpenCode on left" })

      vim.api.nvim_create_user_command("OpenCodeRight", function()
        close_opencode_terminal()
        open_terminal_right()
      end, { desc = "Open OpenCode on right" })

      vim.api.nvim_create_user_command("OpenCodeBottom", function()
        close_opencode_terminal()
        open_terminal_bottom()
      end, { desc = "Open OpenCode on bottom" })

      vim.api.nvim_create_user_command("OpenCodeFloat", function()
        close_opencode_terminal()
        open_terminal_float()
      end, { desc = "Open OpenCode in floating window" })

      vim.api.nvim_create_user_command("OpenCodeClose", close_opencode_terminal, {
        desc = "Close OpenCode terminal"
      })

      vim.api.nvim_create_user_command("OpenCodeFocus", focus_opencode, {
        desc = "Focus OpenCode terminal"
      })

      vim.api.nvim_create_user_command("OpenCodeSendFile", send_file_path, {
        desc = "Send current file path to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendSelection", send_selection, {
        desc = "Send selection to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendBuffer", send_buffer_content, {
        desc = "Send buffer content to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendDiagnostics", send_diagnostics, {
        desc = "Send diagnostics to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendDiff", send_git_diff, {
        desc = "Send git diff to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendStatus", send_git_status, {
        desc = "Send git status to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSendContext", send_project_context, {
        desc = "Send project context to clipboard and focus OpenCode"
      })

      vim.api.nvim_create_user_command("OpenCodeSetWidth", function(opts)
        local pct = tonumber(opts.args)
        if pct and pct > 0 and pct <= 100 then
          state.width_percent = pct / 100
          save_session()
          vim.notify("OpenCode width set to " .. pct .. "%", vim.log.levels.INFO)
        else
          vim.notify("Invalid width. Use a number between 1-100", vim.log.levels.ERROR)
        end
      end, { nargs = 1, desc = "Set OpenCode terminal width percentage" })

      vim.api.nvim_create_user_command("OpenCodeSetHeight", function(opts)
        local pct = tonumber(opts.args)
        if pct and pct > 0 and pct <= 100 then
          state.height_percent = pct / 100
          save_session()
          vim.notify("OpenCode height set to " .. pct .. "%", vim.log.levels.INFO)
        else
          vim.notify("Invalid height. Use a number between 1-100", vim.log.levels.ERROR)
        end
      end, { nargs = 1, desc = "Set OpenCode terminal height percentage" })

      -- ============================================
      -- AUTO-STYLING FOR OPENCODE TERMINALS
      -- ============================================
      vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
        pattern = "*",
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("term://") and bufname:match("opencode") then
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.foldcolumn = "0"
            vim.opt_local.winhighlight = "Normal:Normal,NormalNC:Normal"
            vim.opt_local.fillchars = "eob: "

            -- Terminal mode escape and navigation keybindings
            local buf = vim.api.nvim_get_current_buf()

            -- Double-tap Escape to exit terminal mode, then you can use arrow keys
            -- (which are already mapped for window navigation in normal mode)
            vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = buf, desc = "Exit terminal mode" })

            -- Direct window navigation from terminal mode (bypasses OpenCode)
            -- Ctrl + arrow keys
            vim.keymap.set("t", "<C-Left>", [[<C-\><C-n><C-w>h]], { buffer = buf, desc = "Window left" })
            vim.keymap.set("t", "<C-Right>", [[<C-\><C-n><C-w>l]], { buffer = buf, desc = "Window right" })
            vim.keymap.set("t", "<C-Up>", [[<C-\><C-n><C-w>k]], { buffer = buf, desc = "Window up" })
            vim.keymap.set("t", "<C-Down>", [[<C-\><C-n><C-w>j]], { buffer = buf, desc = "Window down" })

            -- Ctrl-o as a quick "go back to last window"
            vim.keymap.set("t", "<C-o>", [[<C-\><C-n><C-w>p]], { buffer = buf, desc = "Previous window" })
          end
        end,
      })

      -- Terminal colors
      vim.cmd([[
        highlight! link TermNormal Normal
        highlight! link TermNormalNC Normal
      ]])
    end,
    keys = {
      -- Toggle and position
      { "<leader>oc", "<cmd>OpenCode<cr>",           desc = "Toggle OpenCode" },
      { "<leader>oC", "<cmd>OpenCodeClose<cr>",      desc = "Close OpenCode" },
      { "<leader>of", "<cmd>OpenCodeFocus<cr>",      desc = "Focus OpenCode" },
      { "<leader>ol", "<cmd>OpenCodeLeft<cr>",       desc = "OpenCode Left" },
      { "<leader>or", "<cmd>OpenCodeRight<cr>",      desc = "OpenCode Right" },
      { "<leader>ob", "<cmd>OpenCodeBottom<cr>",     desc = "OpenCode Bottom" },
      { "<leader>oF", "<cmd>OpenCodeFloat<cr>",      desc = "OpenCode Float" },

      -- Send context
      { "<leader>op", "<cmd>OpenCodeSendFile<cr>",        desc = "Send file path" },
      { "<leader>os", "<cmd>OpenCodeSendSelection<cr>",   desc = "Send selection", mode = "v" },
      { "<leader>oB", "<cmd>OpenCodeSendBuffer<cr>",      desc = "Send buffer" },
      { "<leader>od", "<cmd>OpenCodeSendDiagnostics<cr>", desc = "Send diagnostics" },
      { "<leader>og", "<cmd>OpenCodeSendDiff<cr>",        desc = "Send git diff" },
      { "<leader>oG", "<cmd>OpenCodeSendStatus<cr>",      desc = "Send git status" },
      { "<leader>ox", "<cmd>OpenCodeSendContext<cr>",     desc = "Send project context" },
    },
  },
}
