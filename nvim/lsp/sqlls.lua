return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/sql-language-server", "up", "--method", "stdio" },
  root_markers = { ".git", "package.json" },
  filetypes = { "sql", "mysql" },
  settings = {},
}