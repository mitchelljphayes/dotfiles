return {
  -- Linting support
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      -- Configure linters by filetype
      lint.linters_by_ft = {
        sql = { "sqlfluff" },
        python = { "ruff" },
        javascript = { "eslint" },
        typescript = { "eslint" },
      }
      
      -- Configure sqlfluff
      lint.linters.sqlfluff.args = {
        "lint",
        "--format", "json",
        "-",
      }
      
      -- Set up autocmd to trigger linting
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}