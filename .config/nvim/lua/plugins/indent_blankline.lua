local M = {
	"lukas-reineke/indent-blankline.nvim",
}

function M.config()
	require("indent_blankline").setup({
		char = "",
		show_current_context = true,
		show_current_context_start = false,
		show_trailing_blankline_indent = false,
		space_char_blankline = " ",
		max_indent_increase = 1,
	})
end

return M
