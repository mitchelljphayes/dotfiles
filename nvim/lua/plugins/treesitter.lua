return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]]
    -- See `:help nvim-treesitter`
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'markdown', 'markdown_inline' },

      sync_install = false,
      ignore_install = { "javascript" },
      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = true,
      modules = {},
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['sa'] = '@parameter.outer',
            ['si'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            -- [']]'] = '@class.outer', -- Disabled to preserve paragraph navigation
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            -- [']['] = '@class.outer', -- Disabled to preserve paragraph navigation
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            -- ['[['] = '@class.outer', -- Disabled to preserve paragraph navigation
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            -- ['[]'] = '@class.outer', -- Disabled to preserve paragraph navigation
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>s'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>S'] = '@parameter.inner',
          },
        },
      },
    }
  end
}
