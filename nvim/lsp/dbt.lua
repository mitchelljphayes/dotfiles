-- dbt-specific configuration
-- This handles SQL files with Jinja2/Liquid templating

-- First, let's check if there's a dbt language server available
-- Options include:
-- 1. dbt-language-server (if available)
-- 2. sqls with custom configuration
-- 3. Disable diagnostics for dbt files

-- For now, we'll use sqls but with adjusted settings for dbt files
return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/sqls" },
  root_markers = { "dbt_project.yml", ".git" },
  filetypes = { "sql" },
  -- We can add custom settings here if sqls supports them
  settings = {
    sqls = {
      -- Potentially add configuration to be more lenient with syntax
    }
  },
  -- Custom on_attach to disable certain diagnostics for dbt files
  on_attach = function(client, bufnr)
    -- Check if this is a dbt file
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath:match("/models/") or 
       filepath:match("/macros/") or 
       filepath:match("/tests/") or 
       filepath:match("/seeds/") or 
       filepath:match("/snapshots/") or 
       filepath:match("/analyses/") or
       filepath:match("%.dbt%.sql$") then
      -- For dbt files, we might want to disable diagnostics
      -- or filter them to ignore Jinja2 syntax
      vim.diagnostic.disable(bufnr)
      vim.notify("dbt file detected - diagnostics disabled", vim.log.levels.INFO)
    end
  end,
}