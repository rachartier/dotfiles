return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",

		"nvim-neotest/neotest-python",
	},
	lazy = true,
	keys = {
		{ "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run Neotest" },
		{ "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", desc = "Run Neotest File" },
		{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle Neotest Summary" },
		{
			"<leader>to",
			"<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<CR>",
			desc = "Open Neotest Output",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					runner = "unittest",
				}),
			},
		})
	end,
}
