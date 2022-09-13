local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("mitch.lsp.lsp-installer")
require("mitch.lsp.handlers").setup()
require("mitch.lsp.null-ls")
