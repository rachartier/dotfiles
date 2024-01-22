local M = {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	enabled = false,
}

function M.config()
	require("codeium").setup({})
end

return M
