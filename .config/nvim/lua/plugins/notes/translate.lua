local M = {
	"potamides/pantran.nvim",
	keys = {
		{ mode = { "n", "x" }, "<leader>tr", "<cmd>Pantran<cr>", desc = "Translate" },
	},
}

function M.config()
	require("pantran").setup({
		default_engine = "google",
		command = {
			default_mode = "replace",
		},
	})
end

return M
