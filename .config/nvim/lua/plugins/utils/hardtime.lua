return {

	"m4xshen/hardtime.nvim",
	event = "BufEnter",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		disable_mouse = false,
		restriction_mode = "hint",
		disabled_keys = {
			["<Up>"] = {},
			["<Down>"] = {},
			["<Left>"] = {},
			["<Right>"] = {},
		},
	},
}
