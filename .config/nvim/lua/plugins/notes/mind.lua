local M = {
	"rachartier/mind.nvim",
}

function M.config()
	require("mind").setup({
		ui = {
			width = 35,
		},
	})
end

return M
