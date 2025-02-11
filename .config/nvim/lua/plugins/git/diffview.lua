return {
	"sindrets/diffview.nvim",
	cond = vim.g.dotfile_config_type ~= "minimal",
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
