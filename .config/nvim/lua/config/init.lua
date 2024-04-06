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

M.extras = {
	"debugpy",
	"netcoredbg",
	-- "ruff",
}

local linter_config = require("utils").linter_config_folder

local U = require("utils")
vim.fn.sign_define("DiagnosticSignError", { text = U.diagnostic_signs.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = U.diagnostic_signs.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = U.diagnostic_signs.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = U.diagnostic_signs.hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	float = { border = U.default_border },
	underline = true,
	update_in_insert = false,
	virtual_lines = {
		highlight_whole_line = false,
		only_current_line = true,
	},
	virtual_text = {
		--   spacing = 4,
		-- source = "if_many",
		prefix = "●",
		-- prefix = "icons",
	},
	-- virtual_text = {
	-- 	prefix = function(diagnostic)
	-- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
	-- 			return U.diagnostic_signs.error
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
	-- 			return U.diagnostic_signs.warning
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
	-- 			return U.diagnostic_signs.info
	-- 		else
	-- 			return U.diagnostic_signs.hint
	-- 		end
	-- 	end,
	-- },
	signs = {
		["WARN"] = U.diagnostic_signs.warning,
		["ERROR"] = U.diagnostic_signs.error,
		["INFO"] = U.diagnostic_signs.info,
		["HINT"] = U.diagnostic_signs.hint,
	},
	severity_sort = true,
})

return M
