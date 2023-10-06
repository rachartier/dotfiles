local M = {
	"SmiteshP/nvim-navbuddy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>fn", "<cmd>Navbuddy<cr>", desc = "Open NavBuddy" },
	},
}

function M.config()
	require("nvim-navbuddy").setup({
		lsp = {
			auto_attach = true, -- If set to true, you don't need to manually use attach function
		},
	})
end

return M
