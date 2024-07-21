return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "LazyFile",
	cmd = { "TodoTrouble", "TodoTelescope" },
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Toggle TODO list" } },
	},
	config = function()
		require("todo-comments").setup()
	end,
}
