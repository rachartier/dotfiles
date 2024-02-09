local M = {
	"akinsho/git-conflict.nvim",
}

function M.config()
	require("git-conflict").setup({
		default_mappings = {
			ours = "o",
			theirs = "t",
			none = "0",
			both = "b",
			next = "n",
			prev = "p",
		},
	})

	vim.keymap.set("n", "<leader>gc", ":GitConflictListQf<CR>", { desc = "List git conflicts" })
end

return M
