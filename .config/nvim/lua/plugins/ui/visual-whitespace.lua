return {
	"mcauley-penney/visual-whitespace.nvim",
	event = "BufRead",
	opts = function()
		local colors = require("theme").get_colors()

		return {
			highlight = { bg = colors.surface0, fg = colors.surface2 },
		}
	end,
}
