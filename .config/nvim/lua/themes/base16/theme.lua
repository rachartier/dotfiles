require("base16-colorscheme").with_config({
	telescope = true,
	telescope_borders = true,
	indentblankline = true,
	notify = true,
	ts_rainbow = true,
	cmp = true,
	illuminate = true,
	lsp_semantic = true,
	mini_completion = true,
})

vim.cmd("colorscheme base16-catppuccin-macchiato")

local base16_colors = require("base16-colorscheme").colors

local colors = {
	surface0 = base16_colors.base02,
	surface2 = base16_colors.base04,
	overlay1 = base16_colors.base03,
	overlay2 = base16_colors.base05,
	mantle = base16_colors.base01,
	crust = base16_colors.base00,
	pink = base16_colors.base0E,
	green = base16_colors.base0B,
	red = base16_colors.base08,
	yellow = base16_colors.base0A,
	blue = base16_colors.base0D,
	flamingo = base16_colors.base0F,
	text = base16_colors.base07,
	peach = base16_colors.base0F,
	base = base16_colors.base00,
	subtext1 = base16_colors.base06,
	orange = base16_colors.base09,
}

local global_highlight = {
	-- Visual = { bg = "#234370" },
	Visual = { bg = "#5B6076" },
	-- Visual = { bg = colors.blue, fg = colors.crust },
	LineNr = {
		fg = colors.overlay1,
	},
	CursorLineNr = {
		fg = colors.mauve,
	},
	NormalFloat = {
		bg = "None",
		fg = colors.text,
	},
	NoiceCmdlinePopupBorder = {
		link = "NormalFloat",
	},
	NoiceFormatLevelOff = {
		bg = colors.yellow,
	},
	FloatBorder = {
		bg = "None",
		fg = colors.text,
	},
	FloatTitle = {
		fg = colors.text,
	},
	PopupBorder = {
		link = "FloatBorder",
	},
	PopupNormal = {
		bg = "None",
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
		bg = "None",
	},
	IlluminatedWordRead = {
		bold = true,
		bg = colors.surface1,
	},
	IlluminatedWordWrite = {
		link = "IlluminatedWordRead",
	},
	IluminatedReferenceText = {
		link = "IlluminatedWordRead",
	},
	CmpItemAbbrMatch = {
		fg = colors.blue,
	},
	CmpItemAbbrMatchFuzzy = {
		fg = colors.sapphire,
	},
	TelescopeSelection = {
		link = "PmenuSel",
	},
	FlashLabel = {
		fg = "#000000",
		bg = "#FFFF00",
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
		link = "Comment",
	},
	LspSignatureActiveParameter = {
		bg = colors.peach,
		fg = colors.crust,
	},
}

for hl, col in pairs(global_highlight) do
	vim.api.nvim_set_hl(0, hl, col)
end

local TelescopeColor = {
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

	-- TelescopeBorder = { fg = colors.base },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end

vim.api.nvim_set_hl(0, "@parameter", { fg = colors.lavender, italic = false })
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
