local M = {
	"johmsalas/text-case.nvim",
	keys = {
		"ga",
	},
}

function M.config()
	require("textcase").setup({})
	require("telescope").load_extension("textcase")
	vim.keymap.set({ "n", "v" }, "ga", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Change word case" })
end

return M
