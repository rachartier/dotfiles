local M = {}

local U = require("utils")

function M.get(colors)
	local bg = colors.bg

	if vim.g.neovide then
		bg = colors.base
	end

	return {
		-- Visual = { bg = "#234370" },
		Visual = { bg = colors.surface1 },
		-- Visual = { bg = colors.blue, fg = colors.crust },
		LineNr = {
			fg = colors.surface1,
		},
		CursorLineNr = {
			fg = colors.overlay1,
		},
		CursorLineSign = {
			fg = colors.surface0,
		},

		SignColumn = {
			fg = colors.surface0,
		},
		CursorLine = {
			bg = "None",
		},
		NormalFloat = {
			bg = bg,
			fg = colors.text,
		},
		FloatBorder = {
			-- bg = "None",
			bg = bg,
			fg = colors.surface0,
		},
		NoiceCmdlinePopupBorder = {
			link = "FloatBorder",
		},
		NoiceFormatLevelOff = {
			bg = colors.yellow,
		},
		FloatTitle = {
			fg = colors.text,
		},
		PopupBorder = {
			link = "FloatBorder",
		},
		PopupNormal = {
			-- bg = "None",
			bg = bg,
			fg = colors.text,
		},
		Pmenu = {
			link = "FloatBorder",
		},
		PmenuBorder = {
			link = "FloatBorder",
		},
		PmenuDocBorder = {
			link = "FloatBorder",
		},
		PmenuSel = {
			-- link = "Visual",
			bg = colors.surface0,
		},
		NeoTreeNormal = {
			-- bg = "None",
			bg = bg,
		},
		IlluminatedWordRead = {
			bold = true,
			bg = colors.surface1,
		},
		IlluminatedWordWrite = {
			link = "IlluminatedWordRead",
		},
		IlluminatedReferenceText = {
			link = "IlluminatedWordRead",
		},
		CmpItemAbbrMatch = {
			fg = colors.yellow,
			-- bold = true,
			-- underline = true,
		},
		CmpItemAbbrMatchFuzzy = {
			-- fg = colors.blue,
			-- underline = true,
			link = "CmpItemAbbrMatch",
		},
		TelescopeSelection = {
			link = "PmenuSel",
		},
		FlashLabel = {
			fg = colors.crust,
			bg = colors.yellow,
			bold = true,
		},
		NeoTreeIndentMarker = {
			fg = colors.surface0,
		},
		NeoTreeCursorLine = {
			link = "PmenuSel",
		},
		NoicePopupmenu = {
			link = "PopupNormal",
		},
		NoicePopupmenuBorder = {
			link = "FloatBorder",
		},
		MiniIndentscopeSymbol = {
			fg = colors.surface0,
		},
		LspSignatureActiveParameter = {
			bg = colors.peach,
			fg = colors.crust,
		},
		GitSignsChange = {
			fg = colors.blue,
		},
		GitSignsAdd = {
			fg = colors.green,
		},
		SwitchBufferStatusColor = {
			fg = colors.red,
		},
		CmpGhostText = { link = "Comment", default = true },
		LspLens = { italic = true, fg = colors.surface1 },
		-- StatusLine = {
		--     bg = colors.mantle,
		-- },
		--
		-- StatusLineNC = {
		--     link = "StatusLine",
		-- },

		DiagnosticError = { fg = colors.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticWarn = { fg = colors.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticInfo = { fg = colors.blue }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
		DiagnosticHint = { fg = colors.teal }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default

		DiagnosticVirtualTextError = { bg = U.darken(colors.red, 0.1), fg = colors.red }, -- Used for "Error" diagnostic virtual text
		DiagnosticVirtualTextWarn = { bg = U.darken(colors.yellow, 0.1), fg = colors.yellow }, -- Used for "Warning" diagnostic virtual text
		DiagnosticVirtualTextInfo = { bg = U.darken(colors.blue, 0.1), fg = colors.blue }, -- Used for "Information" diagnostic virtual text
		DiagnosticVirtualTextHint = { bg = U.darken(colors.teal, 0.1), fg = colors.teal }, -- Used for "Hint" diagnostic virtual text

		TelescopeMatching = { link = "CmpItemAbbrMatch" },

		TelescopePromptPrefix = { bg = colors.bg },
		TelescopePromptNormal = { bg = colors.bg },
		TelescopePromptBorder = { link = "FloatBorder" },
		TelescopePromptTitle = { bg = colors.bg, fg = colors.pink },

		TelescopeResultsNormal = { fg = colors.subtext1 },
		TelescopeResultsBorder = { link = "TelescopePromptBorder" },
		TelescopeResultsTitle = { bg = colors.bg, fg = colors.blue },

		TelescopePreviewBorder = { link = "TelescopePromptBorder" },
		TelescopePreviewNormal = {},
		TelescopePreviewTitle = { bg = colors.bg, fg = colors.green },

		WinSeparator = { fg = colors.surface0 },
		WinBar = { fg = colors.rosewater, bg = colors.base },

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
	vim.api.nvim_set_hl(0, "@_parent", { fg = colors.peach })
	vim.api.nvim_set_hl(0, "@attribute", { fg = colors.lavender, italic = true })
	vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@repeat" })
	vim.api.nvim_set_hl(0, "@operator", { fg = colors.teal, italic = false })
	vim.api.nvim_set_hl(0, "@property", { fg = colors.text })
	vim.api.nvim_set_hl(0, "@storageclass", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@type.qualifier", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@variable", { fg = colors.text, italic = false })
	vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@variable.member", { fg = colors.text })
	vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.red, italic = true })
end

return M
