local colors = require("theme").get_colors()

return {
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {
			legacy_computing_symbols_support = true,
			normal_bg = colors.base,
			-- trailing_exponent = 0.3,
			-- trailing_stiffness = 0.5,
			stiffness = 0.5,
			-- stiffness = 0.6,
			trailing_stiffness = 0.25,
			-- trailing_exponent = 0.1,
			-- gamma = 1,
		},
	},
}
