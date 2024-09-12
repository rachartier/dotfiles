return {
	"aaronhallaert/advanced-git-search.nvim",
	cmd = { "AdvancedGitSearch" },
	keys = {
		{ mode = "n", "<leader>gs", "<cmd>AdvancedGitSearch<CR>", { noremap = true, silent = true } },
	},
	config = function()
		require("telescope").load_extension("advanced_git_search")
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		{
			"shumphrey/fugitive-gitlab.vim",
			dependencies = {
				"tpope/vim-fugitive",
			},
			opts = {},
			config = function()
				vim.g.fugitive_gitlab_domains = {
					["ssh://git@gitlab.michelin.com"] = "https://gitlab.michelin.com",
				}
			end,
		},
		"sindrets/diffview.nvim",
	},
}
