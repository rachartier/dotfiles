return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	keys = {
		{
			"<CR>",
			"<cmd>lua require('kulala').run()<cr>",
			{ noremap = true, silent = true, desc = "Execute the request" },
		},
		{
			"n",
			"]",
			"<cmd>lua require('kulala').jump_next()<cr>",
			{ noremap = true, silent = true, desc = "Jump to the next request" },
		},
		{
			"[",
			"<cmd>lua require('kulala').jump_prev()<cr>",
			{ noremap = true, silent = true, desc = "Jump to the previous request" },
		},
		{
			"<leader>i",
			"<cmd>lua require('kulala').inspect()<cr>",
			{ noremap = true, silent = true, desc = "Inspect the current request" },
		},
	},
	opts = {
		icons = {
			inlay = {
				loading = "⏳",
				done = "✅",
				error = "❌",
			},
		},
	},
}
