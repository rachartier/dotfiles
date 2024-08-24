return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	lazy = true,
	cond = require("config").config_type ~= "minimal",
	opts = {
		window = {
			backdrop = 1,
			options = {},
		},
		plugins = {
			todo = { enabled = true },
			gitsigns = { enabled = true },
		},
	},
}
