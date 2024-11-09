local signs = require("config.ui.signs").full_diagnostic

return {
	"folke/snacks.nvim",
	priority = 900,
	lazy = false,
	enabled = true,
	keys = {},
	opts = {
		styles = {
			notification = {
				border = require("config.ui.border").default_border,
				wo = {
					winblend = 0,
				},
			},
		},
		-- statuscol = {
		-- 	left = { "mark", "sign" },
		-- 	right = { "git" },
		-- 	folds = {
		-- 		open = false, -- show open fold icons
		-- 		git_hl = false, -- use Git Signs hl for fold icons
		-- 	},
		-- 	git = {
		-- 		patterns = { "GitSign", "MiniDiffSign" },
		-- 	},
		-- 	refresh = 50,
		-- },
		notifier = {
			icons = {
				error = signs.error,
				warn = signs.warning,
				info = signs.info,
				trace = signs.hint,
			},
		},
		lazygit = { enabled = false },
		terminal = { enabled = false },
		statuscol = { enabled = false },
		words = {
			debounce = 10,
		},
	},
}
