return {
	"akinsho/git-conflict.nvim",
	cond = vim.g.dotfile_config_type ~= "minimal",
	event = "VeryLazy",
	version = "*",
	config = true,
	keys = {
		{ "<leader>gc", ":GitConflictListQf<CR>", { noremap = true, silent = true, desc = "List git conflicts" } },
	},
	opts = {
		disable_diagnostics = true,
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
