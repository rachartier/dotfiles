return {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-neotest/nvim-nio",
	},
	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		-- ---@diagnostic disable-next-line: duplicate-set-field
		-- vim.ui.input = function(...)
		-- 	require("lazy").load({ plugins = { "dressing.nvim" } })
		-- 	return vim.ui.input(...)
		-- end
	end,
	lazy = true,
	opts = {
		input = {
			border = require("utils").default_border,
			relative = "editor",
			min_width = { 20, 0.4 },
			title_pos = "center",
			enabled = true,
		},
		win_options = {
			winblend = require("config").winblend,
		},
	},
}
