local M = {
	"johmsalas/text-case.nvim",
	key = {
		"ga",
	},
}

function M.config()
	require("textcase").setup({})
	require("telescope").load_extension("textcase")
	vim.keymap.set({ "n", "v" }, "ga", "<cmd>TextCaseOpenTelescopeChange<CR>", { desc = "Change word case" })
end

return M
