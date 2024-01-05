local M = {
	"stevearc/dressing.nvim",
	-- event = "BufRead",
}

function M.config()
	require("dressing").setup({
		win_options = {
			winblend = require("config").winblend,
		},
	})
end

return M
