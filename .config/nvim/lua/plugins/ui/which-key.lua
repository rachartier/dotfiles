return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local icons = require("config.icons")

		require("which-key").setup({
			window = {
				border = icons.default_border,
				position = "bottom", -- bottom, top
				margin = { 1, 4, 1, 2 }, -- extra window margin [top, right, bottom, left]
				padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
				-- winblend = 0,    -- value between 0-100 0 for fully opaque and 100 for fully transparent
			},
			key_labels = {
				["<leader>"] = "SPC",
				["<space>"] = "SPC",
				["<cr>"] = "RET",
				["<tab>"] = "TAB",
			},
		})
	end,
}
