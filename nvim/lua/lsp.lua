-- Configure and enable LSP servers
vim.defer_fn(function()
  -- Check which API is available
  if vim.lsp.config then
    -- Neovim 0.11+ with vim.lsp.config API
    -- The individual server configs in nvim/lsp/*.lua should be picked up automatically
    -- Just need to enable them
    if vim.lsp.enable then
      vim.lsp.enable({'lua_ls', 'pyright', 'rust_analyzer', 'tsserver', 'sqls', 'sqlls'})
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
      python = {
        name = "pyright",
        cmd = { mason_path .. "/bin/pyright-langserver", "--stdio" },
        root_dir = vim.fs.root(0, {'.git', 'pyproject.toml', 'setup.py'}),
      },
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
    vim.notify("LSP attached: " .. client.name)
    
    -- Special handling for SQL files
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local is_dbt_file = filepath:match("/models/") or 
                        filepath:match("/macros/") or 
                        filepath:match("/tests/") or 
                        filepath:match("/seeds/") or 
                        filepath:match("/snapshots/") or 
                        filepath:match("/analyses/") or
                        filepath:match("%.dbt%.sql$") or
                        vim.fn.filereadable(vim.fn.getcwd() .. "/dbt_project.yml") == 1
    
    if is_dbt_file and (client.name == "sqlls" or client.name == "sqls") then
      -- This is a dbt file with a regular SQL LSP, stop it
      vim.lsp.stop_client(client.id)
      vim.notify("Stopping " .. client.name .. " for dbt file (use dbt-ls instead)", vim.log.levels.INFO)
    elseif is_dbt_file and client.name == "dbt-ls" then
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

-- Toggle diagnostics command (useful for dbt files)
vim.api.nvim_create_user_command('DiagnosticsToggle', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.diagnostic.is_disabled(bufnr) then
    vim.diagnostic.enable(bufnr)
    vim.notify("Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable(bufnr)
    vim.notify("Diagnostics disabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle diagnostics for current buffer" })