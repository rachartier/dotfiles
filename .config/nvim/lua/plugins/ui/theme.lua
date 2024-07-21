return {
	{
		"catppuccin/nvim",
		priority = 1000,
		enabled = true,
		lazy = false,
		config = function()
			require("theme").setup()
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		enabled = false,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		enabled = false,
		config = function()
			require("tokyonight").setup()
		end,
	},
	{
		"p00f/alabaster.nvim",
		priority = 1000,
		enabled = false,
	},
}
