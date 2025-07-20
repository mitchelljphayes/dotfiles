return {
  -- Formatting support
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      
      conform.setup({
        formatters_by_ft = {
          sql = { "sqlfluff" },
          python = { "black", "isort" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
        },
        
        -- Configure formatters
        formatters = {
          sqlfluff = {
            command = "sqlfluff",
            args = {
              "fix",
              "--force",
              "-",
            },
            stdin = true,
            cwd = require("conform.util").root_file({ ".sqlfluff", "dbt_project.yml" }),
          },
          prettier = {
            command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
          },
        },
        
        -- Format on save
        format_on_save = function(bufnr)
          -- Disable format on save for certain filetypes
          local ignore_filetypes = { "sql" } -- You might want to manually format SQL
          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,
      })
      
      -- Create format command
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        conform.format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
      
      -- Keymap for formatting
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[C]ode [F]ormat file or range (in visual mode)" })
      
      -- Special handling for dbt SQL files
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.sql" },
        callback = function(args)
          local filepath = vim.api.nvim_buf_get_name(args.buf)
          local is_dbt_file = filepath:match("/models/") or 
                              filepath:match("/macros/") or 
                              filepath:match("/tests/") or 
                              filepath:match("/seeds/") or 
                              filepath:match("/snapshots/") or 
                              filepath:match("/analyses/") or
                              filepath:match("%.dbt%.sql$") or
                              vim.fn.filereadable(vim.fn.getcwd() .. "/dbt_project.yml") == 1
          
          if is_dbt_file then
            -- For dbt files, ensure sqlfluff uses dbt templater
            vim.b.conform_formatters = { "sqlfluff" }
          end
        end,
      })
    end,
  },
}