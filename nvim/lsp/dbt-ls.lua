-- DBT Language Server configuration
-- Using dbtf at ~/.local/bin/dbt

return {
  cmd = { vim.fn.expand("~/.local/bin/dbt"), "lsp" },
  root_markers = { "dbt_project.yml", ".git" },
  filetypes = { "sql", "jinja.sql" },
  single_file_support = false,
  settings = {},
}