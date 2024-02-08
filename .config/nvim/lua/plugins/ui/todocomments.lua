local M = {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = { "BufReadPost", "BufNewFile" },
}

function M.config()
	require("todo-comments").setup({})

	vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Toggle TODO list" })
end

return M
