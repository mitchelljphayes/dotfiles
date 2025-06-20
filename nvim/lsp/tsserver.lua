return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server", "--stdio" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
}