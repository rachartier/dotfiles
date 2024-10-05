local M = {}
local utils = require("utils")

local darken_markdown_heading = 0.18

function M.get(colors)
	-- local bg = colors.base
	local bg = "None"

	-- local cursor_line_bg = U.lighten(colors.base, 0.955)
	local cursor_line_bg = "None"
	return {
		-- Visual = { bg = "#234370" },
		Visual = { bg = colors.surface1 },
		-- Visual = { bg = colors.blue, fg = colors.mantle },

		-- NormalFloat = { bg = bg, fg = colors.text },
		NormalFloat = { bg = colors.mantle, fg = colors.text },
		FloatBorder = { fg = colors.mantle, bg = colors.mantle },
		FloatTitle = { bg = colors.yellow, fg = colors.mantle },
		LineNr = { fg = colors.surface1 },
		SignColumn = { fg = colors.surface1 },
		-- Visual = { bg = colors.surface1 },
		Comment = { fg = colors.surface2, italic = true },

		CmpGhostText = { link = "Comment", default = true },
		CmpItemAbbrMatch = { fg = colors.yellow, bold = true, underline = false },
		CmpItemAbbrMatchFuzzy = { fg = colors.blue, underline = true, link = "CmpItemAbbrMatch" },

		Pmenu = { bg = colors.mantle, fg = colors.text },
		PmenuBorder = { link = "FloatBorder" },
		PmenuDocBorder = { link = "FloatBorder" },
		PmenuSel = { bg = colors.base },
		PopupNormal = { bg = colors.mantle, fg = colors.text },

		-- CursorLine = { bg = colors.surface1 },
		CursorLine = { bg = "None" },
		CursorLineNr = { fg = colors.mauve },
		CursorLineSign = { link = "SignColumn" },
		CursorColumn = { bg = "None" },

		FlashLabel = { fg = colors.mantle, bg = colors.yellow, bold = true },

		AlphaShortcut = { fg = colors.mantle, bg = colors.mauve, bold = true },
		AlphaFooter = { fg = colors.maroon },
		AlphaButtons = { fg = colors.subtext0 },

		GitSignsAdd = { fg = colors.green },
		GitSignsChange = { fg = colors.blue },

		IlluminatedWordRead = { bg = colors.surface1 },
		IlluminatedReferenceText = { link = "IlluminatedWordRead" },
		IlluminatedWordWrite = { link = "IlluminatedWordRead" },

		LspLens = { italic = true, fg = colors.surface1 },
		LspSignatureActiveParameter = { bg = colors.peach, fg = colors.mantle },

		MiniIndentscopeSymbol = { fg = colors.surface0 },
		MarkviewLayer = { bg = colors.surface1, fg = colors.text },

		NeoTreeCursorLine = { link = "PmenuSel" },
		NeoTreeIndentMarker = { fg = colors.surface0 },
		NeoTreeNormal = { bg = colors.mantle },
		NeoTreePreview = { link = "NeoTreeNormal" },

		NoiceCmdlineIcon = { fg = colors.yellow, italic = false, bold = true },
		NoiceCmdlinePopup = { bg = colors.mantle, fg = colors.text },
		NoiceCmdlinePopupBorder = { link = "FloatBorder" },
		NoiceFormatLevelOff = { bg = colors.yellow },
		NoicePopupmenu = { link = "PopupNormal" },
		NoicePopupmenuBorder = { link = "FloatBorder" },

		PopupBorder = { link = "FloatBorder" },
		-- PopupNormal = { bg = colors.mantle, fg = colors.mantle },

		SwitchBufferStatusColor = { fg = colors.red },

		StatusLine = {
			-- fg = colors.base,
			-- bg = "None",
			link = "Normal",
		},

		StatusLineNC = {
			link = "StatusLine",
		},

		-- DiagnosticError = { fg = colors.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		-- DiagnosticWarn = { fg = colors.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		-- DiagnosticInfo = { fg = colors.blue }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		-- DiagnosticHint = { fg = colors.teal }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		--
		-- DiagnosticVirtualTextError = { bg = modify_func(colors.red, darken_diag), fg = colors.red },          -- Used for "Error" diagnostic virtual text
		-- DiagnosticVirtualTextWarn = { bg = modify_func(colors.yellow, darken_diag), fg = colors.yellow },     -- Used for "Warning" diagnostic virtual text
		-- DiagnosticVirtualTextInfo = { bg = modify_func(colors.blue, darken_diag), fg = colors.blue },         -- Used for "Information" diagnostic virtual text
		-- DiagnosticVirtualTextHint = { bg = modify_func(colors.teal, darken_diag), fg = colors.teal },         -- Used for "Hint" diagnostic virtual text
		-- DiagnosticVirtualTextNone = { bg = cursor_line_bg, fg = colors.surface1 },                            -- Used for "Hint" diagnostic virtual text
		--
		-- InvDiagnosticVirtualTextError = { fg = modify_func(colors.red, darken_diag), bg = cursor_line_bg },   -- Used for "Error" diagnostic virtual text
		-- InvDiagnosticVirtualTextWarn = { fg = modify_func(colors.yellow, darken_diag), bg = cursor_line_bg }, -- Used for "Warning" diagnostic virtual text
		-- InvDiagnosticVirtualTextInfo = { fg = modify_func(colors.blue, darken_diag), bg = cursor_line_bg },   -- Used for "Information" diagnostic virtual text
		-- InvDiagnosticVirtualTextHint = { fg = modify_func(colors.teal, darken_diag), bg = cursor_line_bg },   -- Used for "Hint" diagnostic virtual text
		--
		TelescopeMatching = { link = "CmpItemAbbrMatch" },
		TelescopeSelection = { link = "PmenuSel" },

		TelescopePromptPrefix = { fg = colors.blue },
		TelescopePromptNormal = { bg = colors.surface0, fg = colors.text },
		-- TelescopePromptBorder = { bg = colors.mantle, fg = colors.surface0 },
		TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
		TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },

		TelescopeResultsNormal = { bg = colors.mantle, fg = colors.subtext1 },
		TelescopeResultsBorder = { link = "FloatBorder" },
		TelescopeResultsTitle = { bg = colors.blue, fg = colors.mantle },

		TelescopePreviewBorder = { link = "FloatBorder" },
		TelescopePreviewNormal = { bg = colors.mantle },
		TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },

		FzfLuaNormal = { bg = colors.bg, fg = colors.text },
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

		-- StatusLineNC = { fg = colors.surface0 },
		-- StatusLine = { fg = colors.surface0 },

		EdgyNormal = { bg = colors.mantle },
		EdgyWinBar = { bg = colors.surface0, fg = "None" },
		-- EdgyTitle = { bg = colors.surface0, fg = colors.blue },
		-- EdgyIconActive = { bg = colors.surface0, fg = colors.peach },
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

		HighlightUndo = { bg = colors.red, fg = colors.mantle },
		HighlightRedo = { bg = colors.green, fg = colors.mantle },

		AlphaHeader = { fg = colors.yellow, bold = true },
		AlphaNeovimLogoMauve = { fg = colors.mauve },
		AlphaNeovimLogoBlue = { fg = colors.blue },
		AlphaNeovimLogoGreen = { fg = colors.green },
		AlphaNeovimLogoGreenFBlueB = { fg = colors.green, bg = colors.blue },
		CopilotChatSeparator = { fg = colors.surface1 },

		RenderMarkdownChecked = { fg = colors.green },
		RenderMarkdownTodo = { fg = colors.blue },

		RenderMarkdownH1 = { fg = colors.red, bg = utils.darken(colors.red, darken_markdown_heading) },
		RenderMarkdownH2 = { fg = colors.peach, bg = utils.darken(colors.peach, darken_markdown_heading) },
		RenderMarkdownH3 = { fg = colors.yellow, bg = utils.darken(colors.yellow, darken_markdown_heading) },
		RenderMarkdownH4 = { fg = colors.green, bg = utils.darken(colors.green, darken_markdown_heading) },
		RenderMarkdownH5 = { fg = colors.blue, bg = utils.darken(colors.blue, darken_markdown_heading) },
		RenderMarkdownH6 = { fg = colors.mauve, bg = utils.darken(colors.mauve, darken_markdown_heading) },

		RenderMarkdownH1Bg = { link = "RenderMarkdownH1" },
		RenderMarkdownH2Bg = { link = "RenderMarkdownH2" },
		RenderMarkdownH3Bg = { link = "RenderMarkdownH3" },
		RenderMarkdownH4Bg = { link = "RenderMarkdownH4" },
		RenderMarkdownH5Bg = { link = "RenderMarkdownH5" },

		RenderMarkdownListYes = { fg = colors.green },
		RenderMarkdownListNo = { fg = colors.red },
		RenderMarkdownListFire = { fg = colors.red },
		RenderMarkdownListIdea = { fg = colors.yellow },
		RenderMarkdownListStar = { fg = colors.yellow },
		RenderMarkdownListSkipped = { fg = colors.red },
		RenderMarkdownListQuestion = { fg = colors.yellow },
		RenderMarkdownListInfo = { fg = colors.cyan },
		RenderMarkdownListImportant = { fg = colors.peach },

		CopilotSuggestion = { fg = colors.subtext0, italic = false },
		MiniCursorwordCurrent = { bg = colors.surface1 },
		MiniCursorword = { link = "MiniCursorwordCurrent" },

		-- AvanteT,
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
	-- vim.api.nvim_set_hl(0, "@attribute", { italic = true })
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
	vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.red, italic = false })
	-- vim.api.nvim_set_hl(0, "@function.method.call", { italic = true })
	vim.api.nvim_set_hl(0, "@keyword.operator.python", { link = "Conditional" })
	-- vim.api.nvim_set_hl(0, "@string.documentation", { fg = "#7c8c8f" })
end

return M
