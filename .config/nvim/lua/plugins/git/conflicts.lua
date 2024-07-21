return {
	"akinsho/git-conflict.nvim",
	cond = require("config").config_type ~= "minimal",
	event = "VeryLazy",
	keys = {
		{ "n", "<leader>gc", ":GitConflictListQf<CR>", { noremap = true, silent = true, desc = "List git conflicts" } },
	},
	opts = {
		default_mappings = {
			ours = "o",
			theirs = "t",
			none = "0",
			both = "b",
			next = "n",
			prev = "p",
		},
	},
}
