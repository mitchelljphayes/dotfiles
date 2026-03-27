return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      -- Enable highlighting and indentation via Neovim's built-in treesitter API
      -- (the new nvim-treesitter main branch no longer has configs.setup)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Install parsers for these languages automatically on first encounter
      local parsers = require('nvim-treesitter.parsers')
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft)
          if lang and parsers[lang] and not pcall(vim.treesitter.language.inspect, lang) then
            require('nvim-treesitter').install({ lang })
          end
        end,
      })

      -- Pre-install these parsers
      local ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'markdown', 'markdown_inline' }
      require('nvim-treesitter').install(ensure_installed)
    end,
  },
  {
    -- Textobjects (separate plugin on main branch)
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      -- Selection
      vim.keymap.set({ 'x', 'o' }, 'sa', function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer') end)
      vim.keymap.set({ 'x', 'o' }, 'si', function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner') end)
      vim.keymap.set({ 'x', 'o' }, 'af', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer') end)
      vim.keymap.set({ 'x', 'o' }, 'if', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner') end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer') end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner') end)

      -- Movement
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer') end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer') end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer') end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer') end)

      -- Swap
      vim.keymap.set('n', '<leader>s', function() require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner') end)
      vim.keymap.set('n', '<leader>S', function() require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner') end)
    end,
  },
}
