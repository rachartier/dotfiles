return {
	"stevearc/quicker.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>q",
			function()
				require("quicker").toggle()
			end,
			desc = "Toggle quickfix",
		},
		{
			"<leader>l",
			function()
				require("quicker").toggle({ loclist = true })
			end,
			{
				desc = "Toggle loclist",
			},
		},
	},
	opts = {},
}
