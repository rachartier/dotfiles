local M = {}

return {
	{
		"catppuccin/nvim",
		priority = 9999,
		lazy = false,
		enabled = true,
		config = function()
			require("theme").setup()
		end,
	},
}
