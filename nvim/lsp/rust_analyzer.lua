return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  filetypes = { "rust" },
}