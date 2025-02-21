return {
	"sindrets/diffview.nvim",
	cond = vim.g.dotfile_config_type ~= "minimal",
	event = "VeryLazy",
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
