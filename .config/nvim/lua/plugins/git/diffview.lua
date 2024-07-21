return {
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
	opts = {},
}
