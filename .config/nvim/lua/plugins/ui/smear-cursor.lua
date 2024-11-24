local theme = require("theme")

return {
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {
			smear_between_neighbor_lines = true,
			legacy_computing_symbols_support = true,
			cursor_color = theme.get_colors().rosewater,
		},
	},
	-- {
	-- 	"karb94/neoscroll.nvim",
	-- 	opts = {
	-- 		mappings = {
	-- 			"<C-u>",
	-- 			"<C-d>",
	-- 			"<C-b>",
	-- 			"<C-f>",
	-- 			"<C-y>",
	-- 			"<C-e>",
	-- 			"zt",
	-- 			"zz",
	-- 			"zb",
	-- 		},
	-- 		post_hook = function(info)
	-- 			if info == nil then
	-- 				return
	-- 			end
	-- 			if info.kind == "gg" then
	-- 				vim.api.nvim_win_set_cursor(info.winid, { 1, 0 })
	-- 			elseif info.kind == "G" then
	-- 				local line = vim.api.nvim_buf_line_count(info.bufnr)
	-- 				vim.api.nvim_win_set_cursor(info.winid, { line, 0 })
	-- 			end
	-- 		end,
	-- 	},
	-- },
}
