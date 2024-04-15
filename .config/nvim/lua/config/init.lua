local M = {}

if vim.g.neovide then
	M.pumblend = 25 -- Popup blend
	M.winblend = 45 -- Window blend
else
	M.pumblend = 0
	M.winblend = 0
end

M.gif_alpha_enabled = true

M.lsp = require("config.lsp").lsps
M.linters = require("config.linter")
M.formatters = require("config.formatter")
M.others = require("config.icons")

M.extras = {}

return M
