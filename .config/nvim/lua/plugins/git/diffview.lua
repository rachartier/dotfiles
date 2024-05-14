local M = {
	"sindrets/diffview.nvim",
	cond = require("config").config_type ~= "minimal",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewRefresh",
		"DiffviewLog",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
	},
}

function M.config()
	require("diffview").setup()
end

return M
