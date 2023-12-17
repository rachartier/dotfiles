local M = {}

function M.get(colors)
	local bg = "None"

	if vim.g.neovide or colors.base ~= "None" then
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
		CursorLine = {
			bg = "None",
		},
		NormalFloat = {
			bg = bg,
			fg = colors.text,
		},
		NoiceCmdlinePopupBorder = {
			link = "NormalFloat",
		},
		NoiceFormatLevelOff = {
			bg = colors.yellow,
		},
		FloatBorder = {
			-- bg = "None",
			bg = bg,
			fg = colors.text,
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
			fg = colors.mauve,
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

		TelescopeMatching = { link = "CmpItemAbbrMatch" },

		-- TelescopePromptPrefix = { bg = colors.surface0 },
		-- TelescopePromptNormal = { bg = colors.surface0 },
		-- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
		TelescopePromptTitle = { bg = colors.pink, fg = colors.base },

		TelescopeResultsNormal = { fg = colors.subtext1 },
		-- TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
		TelescopeResultsTitle = { bg = colors.blue, fg = colors.base },

		-- TelescopePreviewBorder = { bg = colors.base, fg = colors.base },
		TelescopePreviewNormal = {},
		TelescopePreviewTitle = { bg = colors.green, fg = colors.base },
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

	vim.api.nvim_set_hl(0, "@parameter", { fg = colors.red, italic = true })
	vim.api.nvim_set_hl(0, "@variable", { fg = colors.text, italic = false })
	vim.api.nvim_set_hl(0, "@operator", { fg = colors.teal, italic = false })
	vim.api.nvim_set_hl(0, "@attribute", { fg = colors.lavender, italic = true })
	vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@repeat" })

	vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@type.qualifier", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@storageclass", { fg = colors.red })
	vim.api.nvim_set_hl(0, "@field", { fg = colors.red })

	vim.api.nvim_set_hl(0, "@property", { fg = colors.text })
	vim.api.nvim_set_hl(0, "@field", { fg = colors.text })

	vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })

	-- vim.api.nvim_set_hl(0, "@variable", { fg = colors.text })
	vim.api.nvim_set_hl(0, "@_parent", { fg = colors.peach })
end

return M
