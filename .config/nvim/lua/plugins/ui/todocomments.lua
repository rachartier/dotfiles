return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Toggle TODO list" } },
	},
}
