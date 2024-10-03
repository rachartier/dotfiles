return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		win = {
			border = require("config.icons").default_border,
			padding = { 0, 0 }, -- extra window padding [top, right, bottom, left]
			-- winblend = 0,    -- value between 0-100 0 for fully opaque and 100 for fully transparent
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
