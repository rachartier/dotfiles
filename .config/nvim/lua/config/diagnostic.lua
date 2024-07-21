local icons = require("config.icons")
local utils = require("utils")

vim.fn.sign_define("DiagnosticSignError", { text = icons.signs.diagnostic.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = icons.signs.diagnostic.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = icons.signs.diagnostic.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = icons.signs.diagnostic.hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	float = { border = require("config.icons").default_border },
	underline = true,
	update_in_insert = false,
	-- virtual_lines = {
	--     highlight_whole_line = false,
	--     -- only_current_line = true,
	-- },
	virtual_text = false, -- virtual_text = {
	-- 	prefix = function(diagnostic)
	-- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
	-- 			return U.signs.diagnostic.error
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
	-- 			return U.signs.diagnostic.warning
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
	-- 			return U.signs.diagnostic.info
	-- 		else
	-- 			return U.signs.diagnostic.hint
	-- 		end
	-- 	end,
	-- },
	document_highlight = {
		enabled = true,
	},
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.signs.diagnostic.error,
			[vim.diagnostic.severity.WARN] = icons.signs.diagnostic.warning,
			[vim.diagnostic.severity.INFO] = icons.signs.diagnostic.info,
			[vim.diagnostic.severity.HINT] = icons.signs.diagnostic.hint,
			-- [vim.diagnostic.severity.OK] = icons.signs.diagnostic.ok,
		},
	},
	severity_sort = true,
})
