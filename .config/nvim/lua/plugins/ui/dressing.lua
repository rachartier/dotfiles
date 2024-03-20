local M = {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-neotest/nvim-nio",
	},
	-- event = "BufRead",
	-- lazy = true,
}

function M.config()
	require("dressing").setup({
		win_options = {
			winblend = require("config").winblend,
		},
	})
end

return M
