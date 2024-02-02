return {
	{
		"bullets-vim/bullets.vim",
		config = function()
			vim.g.bullets_auto_indent_after_colon = 1
			vim.g.bullets_delete_last_bullet_if_empty = 1
			vim.g.bullets_checkbox_markers = " 󰡖󰡖󰡖X"
			vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-", "std*" }
		end,
	},
	{
		"ellisonleao/glow.nvim",
		ft = "markdown",
		config = function()
			require("glow").setup({
				border = "rounded",
			})
		end,
	},
	{
		"richardbizik/nvim-toc",
		ft = "markdown",
		config = function()
			require("nvim-toc").setup({})
		end,
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
		config = function()
			vim.g.table_mode_corner = "|"
		end,
	},
	-- {
	--     "lukas-reineke/headlines.nvim",
	--     dependencies = "nvim-treesitter/nvim-treesitter",
	--     ft = {
	--         "markdown",
	--         "neorg",
	--     },
	--     config = function()
	--         require("headlines").setup({
	--             markdown = {
	--                 fat_headline_lower_string = "▀",
	--             },
	--         })
	--     end,
	-- },
}
