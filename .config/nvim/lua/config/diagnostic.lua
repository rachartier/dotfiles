local U = require("utils")

vim.fn.sign_define("DiagnosticSignError", { text = U.signs.diagnostic.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = U.signs.diagnostic.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = U.signs.diagnostic.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = U.signs.diagnostic.hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	float = { border = U.default_border },
	underline = true,
	update_in_insert = false,
	virtual_lines = {
		highlight_whole_line = false,
		only_current_line = true,
	},
	virtual_improved = {
		current_line = "only",
	},
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
	signs = {
		["WARN"] = U.signs.diagnostic.warning,
		["ERROR"] = U.signs.diagnostic.error,
		["INFO"] = U.signs.diagnostic.info,
		["HINT"] = U.signs.diagnostic.hint,
	},
	severity_sort = true,
})

local ns = vim.api.nvim_create_namespace("CurlineDiag")
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = args.buf,
			callback = function()
				pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
				local hi = { "Error", "Warn", "Info", "Hint" }
				local curline = vim.api.nvim_win_get_cursor(0)[1]
				local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
				local virt_texts = { { (" "):rep(4) } }
				local separator = " "

				for i, diag in ipairs(diagnostics) do
					if i == #diagnostics then
						separator = ""
					end

					virt_texts[#virt_texts + 1] =
						{ "● " .. diag.message, "DiagnosticVirtualText" .. hi[diag.severity] }

					if i < #diagnostics then
						virt_texts[#virt_texts + 1] = { separator, "Normal" }
					end
				end
				if #diagnostics >= 1 then
					vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
						virt_text = virt_texts,
						hl_mode = "blend",
						-- line_hl_group = "DiagnosticVirtualTextError",
					})
				end
			end,
		})
	end,
})
