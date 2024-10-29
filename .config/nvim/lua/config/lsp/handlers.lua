local M = {}

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = require("config.icons").default_border,
	}),
}

return M
