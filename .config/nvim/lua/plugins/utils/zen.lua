return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	lazy = true,
	cond = require("config").config_type ~= "minimal",
	opts = {
		window = {
			backdrop = 1,
			options = {
				number = false,
				signcolumn = "no",
				relativenumber = false,
			},
		},
	},
}
