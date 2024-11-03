local M = {}

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = require("config.icons").default_border,
	}),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = require("config.icons").default_border,
	}),
}

vim.lsp.handlers["textDocument/hover"] = M.handlers["textDocument/hover"]
vim.lsp.handlers["textDocument/signatureHelp"] = M.handlers["textDocument/signatureHelp"]

return M
