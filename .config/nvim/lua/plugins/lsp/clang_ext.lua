local M = {
	"p00f/clangd_extensions.nvim",
	ft = { "c", "cpp", "objc", "objcpp", "h", "hpp", "hh", "hxx" },
}

function M.config()
	local U = require("utils")

	require("clangd_extensions").setup({
		inlay_hints = {
			-- inline = vim.fn.has("nvim-0.10") == 1,
			inline = false,
			-- Options other than `highlight' and `priority' only work
			-- if `inline' is disabled
			-- Only show inlay hints for the current line
			only_current_line = false,
			-- Event which triggers a refresh of the inlay hints.
			-- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
			-- not that this may cause  higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			-- only_current_line_autocmd = { "CursorHold" },
			-- whether to show parameter hints with the inlay hints or not
			show_parameter_hints = false,
			-- prefix for parameter hints
			parameter_hints_prefix = "<- ",
			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = "=> ",
			-- whether to align to the length of the longest line in the file
			max_len_align = false,
			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,
			-- whether to align to the extreme right or not
			right_align = false,
			-- padding from the right if right_align is true
			right_align_padding = 7,
			-- The color of the hints
			highlight = "Comment",
			-- The highlight group priority for extmark
			priority = 100,
		},
		ast = {
			role_icons = {
				type = "",
				declaration = "",
				expression = "",
				specifier = "",
				statement = "",
				["template argument"] = "",
			},

			kind_icons = {
				Compound = "",
				Recovery = "",
				TranslationUnit = "",
				PackExpansion = "",
				TemplateTypeParm = "",
				TemplateTemplateParm = "",
				TemplateParamObject = "",
			},

			highlights = {
				detail = "Comment",
			},
		},
		memory_usage = {
			border = U.default_border,
		},
		symbol_info = {
			border = U.default_border,
		},
	})
end

return M
