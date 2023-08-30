local M = {
	"lukas-reineke/indent-blankline.nvim",
}

function M.config()
	require("indent_blankline").setup({
		-- char = "|",
		show_current_context = true,
		show_current_context_start = false,
		show_trailing_blankline_indent = true,
		-- space_char_blankline = " ",
		max_indent_increase = 1,
	})
	vim.g.indent_blankline_use_treesitter = false
	vim.g.indent_blankline_show_trailing_blankline_indent = false
end

return M
