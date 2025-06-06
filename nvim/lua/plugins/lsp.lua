return {
  { "mason-org/mason.nvim", 
    version = "^1.0.0", 
    opts={
      ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
      }
    }
  },
  { 
    "mason-org/mason-lspconfig.nvim", 
    version = "^1.0.0", 
    opts={} 
  },
  {"neovim/nvim-lspconfig", version="^1.0.0"},
} -- LSP Configuration & Plugins

--     -- Automatically install LSPs to stdpath for neovim
--     -- Useful status updates for LSP
--     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--     { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
--
--     -- Additional lua configuration, makes nvim stuff amazing!
--     'folke/neodev.nvim',
--   },
--   config = function()
--     -- [[ Configure LSP ]]
--     --  This function gets run when an LSP connects to a particular buffer.
--     local on_attach = function(_, bufnr)
--       -- NOTE: Remember that lua is a real programming language, and as such it is possible
--       -- to define small helper and utility functions so you don't have to repeat yourself
--       -- many times.
--       --
--       -- In this case, we create a function that lets us more easily define mappings specific
--       -- for LSP related items. It sets the mode, buffer and description for us each time.
--       local nmap = function(keys, func, desc)
--         if desc then
--           desc = 'LSP: ' .. desc
--         end
--
--         vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--       end
--
--       nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--       nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--       nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--       nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--       nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--       nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--       nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--       nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
--       -- See `:help K` for why this keymap
--       nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--       nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
--       -- Lesser used LSP functionality
--       nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--       nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--       nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--       nmap('<leader>wl', function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--       end, '[W]orkspace [L]ist Folders')
--
--       -- Create a command `:Format` local to the LSP buffer
--       vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--         vim.lsp.buf.format()
--       end, { desc = 'Format current buffer with LSP' })
--     end
--
--     -- Enable the following language servers
--     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--     --
--     --  Add any additional override configuration in the following tables. They will be passed to
--     --  the `settings` field of the server config. You must look up that documentation yourself.
--     local servers = {
--       -- clangd = {},
--       -- gopls = {},
--       pyright = {},
--       rust_analyzer = {},
--       -- tsserver = {},
--
--       lua_ls = {
--         Lua = {
--           workspace = { checkThirdParty = false },
--           telemetry = { enable = false },
--         },
--       },
--     }
--
--     -- Enable Astro support
--     require 'nvim-treesitter.configs'
--
--     -- Setup neovim lua configuration
--     require('neodev').setup()
--
--     -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
--     local capabilities = vim.lsp.protocol.make_client_capabilities()
--     capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
--     -- Ensure the servers above are installed
--     local mason_lspconfig = require 'mason-lspconfig'
--
--     mason_lspconfig.setup {
--       ensure_installed = vim.tbl_keys(servers),
--     }
--
--     mason_lspconfig.setup_handlers {
--       function(server_name)
--         require('lspconfig')[server_name].setup {
--           capabilities = capabilities,
--           on_attach = on_attach,
--           settings = servers[server_name],
--         }
--       end,
--     }
--
--     -- Diagnostic keymaps
--     vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
--     vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
--     vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
--     vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--   end,
-- }--,
-- -- none-ls
-- -- {
-- --   'nvimtools/none-ls.nvim',
-- --   config = function()
-- --     local null_ls = require 'null-ls'
-- --     null_ls.setup {
-- --       sources = {
-- --         null_ls.builtins.formatting.stylua,
-- --         null_ls.builtins.formatting.clang_format,
-- --         null_ls.builtins.formatting.prettier,
-- --         null_ls.builtins.formatting.black,
-- --         null_ls.builtins.formatting.isort,
-- --         null_ls.builtins.diagnostics.eslint_d,
-- --       },
-- --     }
-- --   end,
-- -- }
