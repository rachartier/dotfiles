return {
	{
		"catppuccin/nvim",
		priority = 1000,
		enabled = true,
		config = function()
			require("theme").setup()
		end,
	},
}
