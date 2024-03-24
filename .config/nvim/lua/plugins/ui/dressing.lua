local M = {
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
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
	-- event = "BufRead",
	lazy = true,
}

function M.config()
	require("dressing").setup({
		win_options = {
			winblend = require("config").winblend,
		},
	})
end

return M
