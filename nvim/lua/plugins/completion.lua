return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      },
    }
-- opts = function()
--   vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
--   local cmp = require("cmp")
--   local defaults = require("cmp.config.default")()
--   local auto_select = true
--   return {
--     auto_brackets = {}, -- configure any filetype to auto add brackets
--     completion = {
--       completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
--     },
--     preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
--     mapping = cmp.mapping.preset.insert({
--       ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--       ["<C-f>"] = cmp.mapping.scroll_docs(4),
--       ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--       ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--       ["<C-Space>"] = cmp.mapping.complete(),
--       ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
--       ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
--       ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--       ["<C-CR>"] = function(fallback)
--         cmp.abort()
--         fallback()
--       end,
--       ["<tab>"] = function(fallback)
--         return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
--       end,
--     }),
--     sources = cmp.config.sources({
--       { name = "lazydev" },
--       { name = "nvim_lsp" },
--       { name = "path" },
--     }, {
--       { name = "buffer" },
--     }),
--     formatting = {
--       format = function(entry, item)
--         local icons = LazyVim.config.icons.kinds
--         if icons[item.kind] then
--           item.kind = icons[item.kind] .. item.kind
--         end
--
--         local widths = {
--           abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
--           menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
--         }
--
--         for key, width in pairs(widths) do
--           if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
--             item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
--           end
--         end
--
--         return item
--       end,
--     },
--     experimental = {
--       -- only show ghost text when we show ai completions
--       ghost_text = vim.g.ai_cmp and {
--         hl_group = "CmpGhostText",
--       } or false,
--     },
--     sorting = defaults.sorting,
--   }
  end
}
