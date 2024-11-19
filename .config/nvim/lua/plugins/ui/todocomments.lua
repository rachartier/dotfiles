return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "LazyFile",
	cmd = { "TodoTrouble", "TodoTelescope" },
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Toggle TODO list" } },
	},
	opts = {},
}
