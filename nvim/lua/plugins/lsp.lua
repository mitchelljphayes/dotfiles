return {
  -- Mason: Portable package manager for Neovim
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  
  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua-language-server",
          "pyright",
          "rust-analyzer",
          "typescript-language-server",
          "sqls", -- SQL Language Server
          "sqlls", -- Alternative SQL Language Server with better diagnostics
          "sqlfluff", -- SQL linter with dbt support
          "yaml-language-server", -- YAML LSP
          "prettier", -- Formatter for JS/TS/JSON/YAML/MD
        },
        auto_update = true,
        run_on_start = true,
      })
    end
  },
}