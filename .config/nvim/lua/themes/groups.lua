local M = {}

local U = require("utils")

function M.get(colors)
	local bg = colors.mantle

	-- local cursor_line_bg = U.darken(colors.surface0, 0.5)
	local cursor_line_bg = "None"
	local darken_diag = 0.15

	return {
		-- Visual = { bg = "#234370" },
		-- Visual = { bg = colors.blue, fg = colors.crust },

		NormalFloat = { bg = bg, fg = colors.text },
		LineNr = { fg = colors.surface1 },
		SignColumn = { fg = colors.surface0 },
		Visual = { bg = colors.surface1 },

		CmpGhostText = { link = "Comment", default = true },
		CmpItemAbbrMatch = { fg = colors.yellow, bold = true, underline = false },
		CmpItemAbbrMatchFuzzy = { fg = colors.blue, underline = true, link = "CmpItemAbbrMatch" },

		CursorLine = { bg = cursor_line_bg },
		CursorLineNr = { fg = colors.overlay1 },
		CursorLineSign = { fg = colors.surface0 },

		FlashLabel = { fg = colors.crust, bg = colors.yellow, bold = true },

		FloatBorder = { bg = bg, fg = bg },
		FloatTitle = { bg = colors.yellow, fg = colors.crust },

		GitSignsAdd = { fg = colors.green },
		GitSignsChange = { fg = colors.blue },

		IlluminatedReferenceText = { link = "IlluminatedWordRead" },
		IlluminatedWordRead = { bold = true, bg = colors.surface1 },
		IlluminatedWordWrite = { link = "IlluminatedWordRead" },

		LspLens = { italic = true, fg = colors.surface1 },
		LspSignatureActiveParameter = { bg = colors.peach, fg = colors.crust },

		MiniIndentscopeSymbol = { fg = colors.surface0 },

		NeoTreeCursorLine = { link = "PmenuSel" },
		NeoTreeFloatTitle = { link = "NeoTreeTitlebar" },
		NeoTreeIndentMarker = { fg = colors.surface0 },
		NeoTreeNormal = { bg = bg },
		NeoTreePreview = { link = "NeoTreeNormal" },

		NoiceCmdlineIcon = { fg = colors.yellow, italic = false, bold = true },
		NoiceCmdlinePopup = { bg = bg, fg = colors.text },
		NoiceCmdlinePopupBorder = { link = "FloatBorder" },
		NoiceFormatLevelOff = { bg = colors.yellow },
		NoicePopupmenu = { link = "PopupNormal" },
		NoicePopupmenuBorder = { link = "FloatBorder" },

		Pmenu = { link = "FloatBorder" },
		PmenuBorder = { link = "FloatBorder" },
		PmenuDocBorder = { link = "FloatBorder" },
		PmenuSel = { link = "Visual" },

		PopupBorder = { link = "FloatBorder" },
		PopupNormal = { bg = bg, fg = colors.text },

		SwitchBufferStatusColor = { fg = colors.red },

		-- StatusLine = {
		--     bg = bg,
		-- },
		--
		-- StatusLineNC = {
		--     link = "StatusLine",
		-- },

		DiagnosticError = { fg = colors.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticWarn = { fg = colors.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticInfo = { fg = colors.blue }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticHint = { fg = colors.teal }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default

		DiagnosticVirtualTextError = { bg = U.darken(colors.red, darken_diag), fg = colors.red }, -- Used for "Error" diagnostic virtual text
		DiagnosticVirtualTextWarn = { bg = U.darken(colors.yellow, darken_diag), fg = colors.yellow }, -- Used for "Warning" diagnostic virtual text
		DiagnosticVirtualTextInfo = { bg = U.darken(colors.blue, darken_diag), fg = colors.blue }, -- Used for "Information" diagnostic virtual text
		DiagnosticVirtualTextHint = { bg = U.darken(colors.teal, darken_diag), fg = colors.teal }, -- Used for "Hint" diagnostic virtual text
		DiagnosticVirtualTextNone = { bg = cursor_line_bg, fg = colors.surface1 }, -- Used for "Hint" diagnostic virtual text

		InvDiagnosticVirtualTextError = { fg = U.darken(colors.red, darken_diag), bg = cursor_line_bg }, -- Used for "Error" diagnostic virtual text
		InvDiagnosticVirtualTextWarn = { fg = U.darken(colors.yellow, darken_diag), bg = cursor_line_bg }, -- Used for "Warning" diagnostic virtual text
		InvDiagnosticVirtualTextInfo = { fg = U.darken(colors.blue, darken_diag), bg = cursor_line_bg }, -- Used for "Information" diagnostic virtual text
		InvDiagnosticVirtualTextHint = { fg = U.darken(colors.teal, darken_diag), bg = cursor_line_bg }, -- Used for "Hint" diagnostic virtual text

		TelescopeMatching = { link = "CmpItemAbbrMatch" },
		TelescopeSelection = { link = "PmenuSel" },

		TelescopePromptPrefix = { fg = colors.blue },
		TelescopePromptNormal = { bg = colors.surface0, fg = colors.text },
		TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
		TelescopePromptTitle = { bg = colors.pink, fg = colors.bg },

		TelescopeResultsNormal = { bg = colors.mantle, fg = colors.subtext1 },
		TelescopeResultsBorder = { link = "FloatBorder" },
		TelescopeResultsTitle = { bg = colors.blue, fg = colors.bg },

		TelescopePreviewBorder = { link = "FloatBorder" },
		TelescopePreviewNormal = { bg = bg },
		TelescopePreviewTitle = { bg = colors.green, fg = colors.bg },

		FzfLuaNormal = { bg = colors.mantle, fg = colors.text },
		FzfPreviewTitle = { bg = colors.blue, fg = colors.text },
		FzfLuaPreviewTitle = { bg = colors.green, fg = colors.mantle },
		FzfLuaBorder = { link = "FloatBorder" },

		WinSeparator = { fg = colors.surface0 },
		WinBar = { fg = colors.rosewater, bg = "None" },

		DapUIPlayPauseNC = { link = "DapUIPlayPause" },
		DapUIRestartNC = { link = "DapUIRestart" },
		DapUIStopNC = { link = "DapUIStop" },
		DapUIUnavailableNC = { link = "DapUIUnavailable" },
		DapUIStepOverNC = { link = "DapUIStepOver" },
		DapUIStepIntoNC = { link = "DapUIStepInto" },
		DapUIStepBackNC = { link = "DapUIStepBack" },
		DapUIStepOutNC = { link = "DapUIStepOut" },

		StatusLineNC = { fg = colors.surface0 },
		StatusLine = { fg = colors.surface0 },

		EdgyNormal = { bg = colors.mantle },
		EdgyWinBar = { bg = colors.surface0 },
		EdgyTitle = { bg = colors.surface0, fg = colors.blue },
		EdgyIconActive = { bg = colors.surface0, fg = colors.peach },

		-- DiagnosticUnderlineError = {
		-- 	underline = true,
		-- 	sp = colors.red,
		-- },
		-- LspDiagnosticsUnderlineError = {
		-- 	underline = true,
		-- 	sp = colors.red,
		-- },
	}
end

function M.override_hl(colors_table)
	local colors = M.get(colors_table)

	for hl, col in pairs(colors) do
		vim.api.nvim_set_hl(0, hl, col)
	end
end

function M.override_lsp_hl(colors_table)
	local colors = colors_table

	-- vim.api.nvim_set_hl(0, "@variable", { fg = colors.text })
	-- vim.api.nvim_set_hl(0, "@_parent", { fg = colors.peach })
	vim.api.nvim_set_hl(0, "@attribute", { fg = colors.lavender, italic = true })
	-- vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@repeat" })
	-- vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@repeat" })
	-- vim.api.nvim_set_hl(0, "@operator", { fg = colors.teal, italic = false })
	-- vim.api.nvim_set_hl(0, "@property", { fg = colors.text })
	-- vim.api.nvim_set_hl(0, "@storageclass", { fg = colors.red })
	-- vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.red })
	-- vim.api.nvim_set_hl(0, "@type.qualifier", { fg = colors.red })
	-- vim.api.nvim_set_hl(0, "@variable", { fg = colors.text, italic = false })
	-- vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })
	-- vim.api.nvim_set_hl(0, "@variable.member", { fg = colors.text })
	vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.red, italic = true })
end

return M
