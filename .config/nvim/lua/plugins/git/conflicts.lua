return {
	"akinsho/git-conflict.nvim",
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
