-- Configure and enable LSP servers
vim.defer_fn(function()
  -- Check which API is available
  if vim.lsp.config then
    -- Neovim 0.11+ with vim.lsp.config API
    -- The individual server configs in nvim/lsp/*.lua should be picked up automatically
    -- Just need to enable them
    if vim.lsp.enable then
      vim.lsp.enable({'lua_ls', 'pyright', 'rust_analyzer', 'tsserver', 'sqls', 'sqlls', 'yamlls'})
    end
  else
    -- Fallback: manually start LSP servers using vim.lsp.start
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    
    -- Define server configurations
    local servers = {
      lua = {
        name = "lua_ls",
        cmd = { mason_path .. "/bin/lua-language-server" },
        root_dir = vim.fs.root(0, {'.git', '.luarc.json'}),
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
      python = dofile(vim.fn.stdpath("config") .. "/lsp/pyright.lua"),
      sql = {
        name = "sqlls",
        cmd = { mason_path .. "/bin/sql-language-server", "up", "--method", "stdio" },
        root_dir = vim.fs.root(0, {'.git'}),
      },
    }
    
    -- Set up autocmd to start servers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"lua", "python", "sql"},
      callback = function(args)
        local server = servers[args.match]
        if server and vim.fn.executable(server.cmd[1]) == 1 then
          vim.lsp.start({
            name = server.name,
            cmd = server.cmd,
            root_dir = server.root_dir or vim.fn.getcwd(),
            settings = server.settings,
          })
        end
      end,
    })
  end
end, 1000)

-- Set up LSP keybindings when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    
    local bufnr = args.buf
    -- Only show attachment message for dbt-ls in dbt projects
    if client.name == "dbt-ls" then
      vim.notify("dbt language server attached", vim.log.levels.INFO)
    end
    local opts = { noremap=true, silent=true, buffer=bufnr }
    local keymap = vim.keymap.set
    
    -- Navigation
    keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    keymap('n', 'gd', vim.lsp.buf.definition, opts)
    keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    keymap('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    keymap('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    keymap('n', '<space>D', vim.lsp.buf.type_definition, opts)
    keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
    keymap('n', '<space>ca', vim.lsp.buf.code_action, opts)
    keymap('n', 'gr', vim.lsp.buf.references, opts)
    keymap('n', '<space>f', function()
      -- Use conform if available, otherwise fall back to LSP
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ lsp_fallback = true, async = true })
      else
        vim.lsp.buf.format { async = true }
      end
    end, opts)
    
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Disable diagnostics in oil buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
  desc = "Disable diagnostics in oil buffers",
})

-- Toggle diagnostics command (useful for dbt files)
vim.api.nvim_create_user_command('DiagnosticsToggle', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
    vim.diagnostic.enable(false, { bufnr = bufnr })
    vim.notify("Diagnostics disabled", vim.log.levels.INFO)
  else
    vim.diagnostic.enable(true, { bufnr = bufnr })
    vim.notify("Diagnostics enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle diagnostics for current buffer" })

-- Clear all diagnostics
vim.api.nvim_create_user_command('DiagnosticsClear', function()
  vim.diagnostic.reset()
  vim.notify("Cleared all diagnostics", vim.log.levels.INFO)
end, { desc = "Clear all diagnostics" })

-- Clear diagnostics for current buffer
vim.api.nvim_create_user_command('DiagnosticsClearBuffer', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(nil, bufnr)
  vim.notify("Cleared diagnostics for current buffer", vim.log.levels.INFO)
end, { desc = "Clear diagnostics for current buffer" })

-- Show diagnostic sources
vim.api.nvim_create_user_command('DiagnosticsShowSources', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)
  local sources = {}
  
  for _, d in ipairs(diagnostics) do
    sources[d.source or "unknown"] = (sources[d.source or "unknown"] or 0) + 1
  end
  
  local lines = {"Diagnostic sources:"}
  for source, count in pairs(sources) do
    table.insert(lines, string.format("  • %s: %d", source, count))
  end
  
  if #lines == 1 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
  else
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end
end, { desc = "Show diagnostic sources" })

-- Modern LSP management commands
vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    vim.notify("No active LSP clients", vim.log.levels.INFO)
    return
  end
  
  local lines = {"Active LSP clients:"}
  for _, client in pairs(clients) do
    table.insert(lines, string.format("  • %s (id: %d)", client.name, client.id))
    if client.root_dir then
      table.insert(lines, string.format("    Root: %s", client.root_dir))
    end
  end
  
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show active LSP clients" })

vim.api.nvim_create_user_command('LspRestart', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in pairs(clients) do
    local client_id = client.id
    local client_name = client.name
    vim.lsp.stop_client(client_id)
    vim.notify("Stopped " .. client_name, vim.log.levels.INFO)
    
    -- Restart by re-triggering FileType autocmd
    vim.defer_fn(function()
      vim.cmd('doautocmd FileType')
      vim.notify("Restarted " .. client_name, vim.log.levels.INFO)
    end, 500)
  end
end, { desc = "Restart LSP for current buffer" })

vim.api.nvim_create_user_command('LspStop', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in pairs(clients) do
    vim.lsp.stop_client(client.id)
    vim.notify("Stopped " .. client.name, vim.log.levels.INFO)
  end
end, { desc = "Stop LSP for current buffer" })

vim.api.nvim_create_user_command('LspStart', function()
  vim.cmd('doautocmd FileType')
  vim.notify("Starting LSP...", vim.log.levels.INFO)
end, { desc = "Start LSP for current buffer" })

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd('tabnew ' .. vim.lsp.get_log_path())
end, { desc = "Open LSP log file" })

-- Python-specific commands
vim.api.nvim_create_user_command('PyrightSetInterpreter', function()
  local venv_path = vim.fn.input("Enter venv path (or press enter to auto-detect): ")
  if venv_path == "" then
    -- Try to auto-detect
    local cwd = vim.fn.getcwd()
    if vim.fn.isdirectory(cwd .. "/.venv") == 1 then
      venv_path = cwd .. "/.venv"
    elseif vim.fn.isdirectory(cwd .. "/venv") == 1 then
      venv_path = cwd .. "/venv"
    else
      vim.notify("No virtual environment found", vim.log.levels.ERROR)
      return
    end
  end
  
  -- Restart pyright with new settings
  local clients = vim.lsp.get_clients({ name = "pyright" })
  for _, client in pairs(clients) do
    client.config.settings.python.pythonPath = venv_path .. "/bin/python"
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    vim.notify("Updated pyright to use: " .. venv_path, vim.log.levels.INFO)
  end
end, { desc = "Set Python interpreter for pyright" })

vim.api.nvim_create_user_command('PyrightShowConfig', function()
  local clients = vim.lsp.get_clients({ name = "pyright" })
  for _, client in pairs(clients) do
    local pythonPath = client.config.settings.python and client.config.settings.python.pythonPath or "Not set"
    vim.notify("Pyright Python path: " .. pythonPath, vim.log.levels.INFO)
  end
end, { desc = "Show current pyright configuration" })

vim.api.nvim_create_user_command('PyrightCreateConfig', function()
  local cwd = vim.fn.getcwd()
  local config_path = cwd .. "/pyrightconfig.json"
  
  if vim.fn.filereadable(config_path) == 1 then
    vim.notify("pyrightconfig.json already exists", vim.log.levels.WARN)
    return
  end
  
  local config = {
    venvPath = ".",
    venv = ".venv",
    typeCheckingMode = "basic",
    useLibraryCodeForTypes = true,
    autoSearchPaths = true,
    exclude = {
      "**/.venv",
      "**/venv",
      "**/__pycache__",
      "**/build",
      "**/cache",
      "**/dist",
      "**/node_modules",
      ".env",
      ".env.*",
      "**/evaluation",
      "**/evaluation_results",
    },
  }
  
  local file = io.open(config_path, "w")
  if file then
    file:write(vim.fn.json_encode(config))
    file:close()
    vim.notify("Created pyrightconfig.json", vim.log.levels.INFO)
    vim.cmd("LspRestart")
  else
    vim.notify("Failed to create pyrightconfig.json", vim.log.levels.ERROR)
  end
end, { desc = "Create pyrightconfig.json for current project" })