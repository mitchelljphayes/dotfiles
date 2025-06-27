return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/sqls" },
  root_markers = { ".git" },
  filetypes = { "sql", "mysql" },
  on_attach = function(client, bufnr)
    -- Check if this is a dbt file
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local is_dbt_file = filepath:match("/models/") or 
                        filepath:match("/macros/") or 
                        filepath:match("/tests/") or 
                        filepath:match("/seeds/") or 
                        filepath:match("/snapshots/") or 
                        filepath:match("/analyses/") or
                        filepath:match("%.dbt%.sql$") or
                        vim.fn.filereadable(vim.fn.getcwd() .. "/dbt_project.yml") == 1
    
    if is_dbt_file then
      -- Disable diagnostics for dbt files to avoid Jinja syntax errors
      vim.diagnostic.enable(false, { bufnr = bufnr })
    end
  end,
}