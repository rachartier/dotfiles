local M = {

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
	square = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
	square_telescope = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
}

M.default_border = M.square
-- M.default_border = M.border.empty
-- M.default_border = "rounded"

return M
