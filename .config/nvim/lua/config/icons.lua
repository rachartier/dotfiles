local M = {}

M.border = {
	round = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	none = { "", "", "", "", "", "", "", "" },
	empty = { " ", " ", " ", " ", " ", " ", " ", " " },
	inner_thick = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" },
	outer_thick = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" },
	cmp_items = { "▛", "▀", "▀", " ", "▄", "▄", "▙", "▌" },
	cmp_doc = { "▀", "▀", "▀", " ", "▄", "▄", "▄", "▏" },
	outer_thin = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
	inner_thin = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" },
	outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
	outer_thick_telescope = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
	rounded_telescope = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}

-- M.default_border = M.border.empty
M.default_border = "rounded"

M.signs = {
	file = {
		modified = "",
		not_saved = "󰉉 ",
		readonly = "󰌾",
		created = "",
		unnamed = "No Name",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
		renamed = "󰑕 ",
		branch = "",
		ignored = " ",
		unstaged = "󰄱 ",
		staged = " ",
		untracked = "",
		-- added = " ",
		-- modified = " ",
		-- removed = " ",
	},
	fzf = {
		git = {
			added = "",
			modified = "",
			removed = "",
			renamed = "󰑕",
		},
	},
	lualine_diagnostic = {
		ok = "",
		error = " ",
		warning = " ",
		warn = " ",
		info = " ",
		hint = " ",
		-- other = "󰠠 ",
	},
	diagnostic = {
		error = "●",
		warning = "●",
		warn = "●",
		info = "●",
		hint = "●",
		other = "●",
	},
	others = {
		copilot = " ",
		copilot_disabled = " ",
	},
}

-- M.diagnostic_signs = {
-- 	error = "●",
-- 	warning = "●",
-- 	info = "●",
-- 	hint = "●",
-- 	other = "●",
-- }

-- M.diagnostic_signs = {
--     error = " ",
--     warning = " ",
--     info = " ",
--     hint = "󱤅 ",
--     other = "󰠠 ",
-- }

M.kind_icons = {
	Text = " ",
	Method = " ",
	Function = "󰊕 ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = "󰏓 ",
	Property = " ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = " ",
	EnumMember = " ",
	Keyword = "󰌋 ",
	Snippet = " ",
	Color = " ",
	File = "󰈙 ",
	Reference = "󰈇 ",
	Folder = " ",
	Constant = "󰏿 ",
	Struct = "󰙅 ",
	Event = " ",
	Operator = " ",
	TypeParameter = "󰘦 ",
	Codeium = " ",
	Version = " ",
	Unknown = "  ",
}

return M
