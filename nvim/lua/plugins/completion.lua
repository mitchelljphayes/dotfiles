return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- LSP completion
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',

      -- Other completion sources
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',

      -- For better SQL completions
      'kristijanhusak/vim-dadbod-completion',

      -- Adds user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Icons for completion items
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      
      -- Load friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load()
      
      -- Helper function for better tab behavior
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function (entry, vim_item)
              -- Show source
              vim_item.menu = ({
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                vim_dadbod_completion = "[DB]",
              })[entry.source.name]
              return vim_item
            end
          }),
        },
        
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
          ['<Down>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false, -- Don't select first item automatically
          }),
          ['<Right>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true, -- Select current item
          }),
          -- Tab is now reserved for Copilot ghost text
          -- S-Tab is now reserved for Copilot accept word
        }),
        
        sources = cmp.config.sources({
          { name = 'copilot', priority = 1100 },
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip', priority = 750 },
          { name = 'nvim_lua', priority = 500 },
        }, {
          { name = 'buffer', priority = 500, keyword_length = 3 },
          { name = 'path', priority = 250 },
        }),
        
        experimental = {
          ghost_text = false,
        },
        
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
      
      -- SQL-specific completion
      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = cmp.config.sources({
          { name = 'vim_dadbod_completion' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
      
      -- Custom cmdline mappings with our navigation keys
      local cmdline_mapping = cmp.mapping.preset.cmdline()
      cmdline_mapping['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'c' })
      cmdline_mapping['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'c' })
      cmdline_mapping['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'c' })
      cmdline_mapping['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'c' })
      
      -- Use buffer source for `/` search
      cmp.setup.cmdline('/', {
        mapping = cmdline_mapping,
        sources = {
          { name = 'buffer' }
        }
      })
      
      -- Use cmdline & path source for ':' commands
      cmp.setup.cmdline(':', {
        mapping = cmdline_mapping,
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  
  -- Better snippet support
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      
      -- Configure LuaSnip
      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
      
      -- Load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Load custom snippets from snippets directory if it exists
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
      
      -- Keymaps for snippet navigation
      vim.keymap.set({"i", "s"}, "<C-l>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })
      
      vim.keymap.set({"i", "s"}, "<C-h>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
    end,
  },
}