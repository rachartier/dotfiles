return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		win = {
			border = require("config.ui.border").default_border,
			padding = { 0, 0 }, -- extra window padding [top, right, bottom, left]
--			winblend = require("config").winblend,
		},
		replace = {
			key = {
				{ "<leader>", "SPC" },
				{ "<space>", "SPC" },
				{ "<cr>", "RET" },
				{ "<tab>", "TAB" },
			},
		},
	},
}
