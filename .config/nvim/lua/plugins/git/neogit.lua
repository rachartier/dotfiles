local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"sindrets/diffview.nvim",
	},
	enabled = false,
}

function M.config()
	local neogit = require("neogit")
	neogit.setup({})
end

return M
