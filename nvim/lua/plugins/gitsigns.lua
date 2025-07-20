return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  -- Git blame inline
  {
    'f-person/git-blame.nvim',
    opts = {
      enabled = true,
      message_template = '<author> • <date> • <summary>',
      date_format = '%r',
      virtual_text_column = 80,
      delay = 500,
    },
    keys = {
      { '<leader>gb', '<cmd>GitBlameToggle<cr>', desc = 'Toggle Git Blame' },
      { '<leader>go', '<cmd>GitBlameOpenCommitURL<cr>', desc = 'Open commit URL' },
      { '<leader>gc', '<cmd>GitBlameCopySHA<cr>', desc = 'Copy commit SHA' },
    },
  },
}
