require("base16-colorscheme").with_config({
	telescope = false,
	telescope_borders = true,
	indentblankline = true,
	notify = true,
	ts_rainbow = true,
	cmp = true,
	illuminate = true,
	lsp_semantic = true,
	mini_completion = true,
})

local base16_colors = {
	base00 = "#1e1e28", -- or #16161D (not catppuccin)
	base01 = "#1a1826",
	base02 = "#302d41",
	base03 = "#575268",
	base04 = "#6e6c7c",
	base05 = "#d7dae0",
	base06 = "#f5e0dc",
	base07 = "#c9cbff",
	base08 = "#f28fad",
	base09 = "#f8bd96",
	base0A = "#fae3b0",
	base0B = "#abe9b3",
	base0C = "#b5e8e0",
	base0D = "#96cdfb",
	base0E = "#ddb6f2",
	base0F = "#f2cdcd",
}

vim.cmd("colorscheme base16-catppuccin")
require("base16-colorscheme").setup(base16_colors)

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
	LineNr = {
		fg = colors.surface2,
	},
	CursorLineNr = {
		fg = colors.yellow,
	},
	LspSignatureActiveParameter = {
		bg = colors.base,
	},
	Pmenu = {
		link = "PopupNormal",
	},
	PmenuSel = {
		bg = colors.blue,
		fg = colors.mantle,
		bold = true,
	},
	PmenuBorder = {
		link = "PopupBorder",
	},
	IlluminatedWordRead = {
		bold = true,
		bg = colors.surface0,
	},
	IlluminatedWordWrite = {
		bold = true,
		bg = colors.surface0,
	},
	IluminatedReferenceText = {
		bold = true,
		bg = colors.surface0,
	},
	CmpItemAbbr = {
		bg = colors.crust,
	},
	DiagnosticWarn = {
		fg = colors.yellow,
	},
	DiagnosticInfo = {
		fg = colors.blue,
	},
}

for hl, col in pairs(global_highlight) do
	vim.api.nvim_set_hl(0, hl, col)
end

local TelescopeColor = {
	TelescopeMatching = {
		fg = colors.blue,
	},
	TelescopeSelection = { fg = colors.text, bold = true },

	TelescopePromptPrefix = { bg = colors.surface0 },
	TelescopePromptNormal = { bg = colors.surface0 },
	TelescopeResultsNormal = { bg = colors.mantle, fg = colors.surface2 },
	TelescopePreviewNormal = { bg = colors.mantle },
	TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
	TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
	TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
	TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
	TelescopeResultsTitle = { fg = colors.mantle },
	TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
	TelescopeBorder = { fg = colors.text },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end
