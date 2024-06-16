return {
	"petertriho/nvim-scrollbar",
	enabled = false,
	opts = {
		throttle_ms = 50,
		handle = {
			text = " ",
			blend = 0, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
			color = nil,
			color_nr = nil, -- cterm
			highlight = "None",
			hide_if_all_visible = true, -- Hides handle if all lines are visible
		},
		excluded_buftypes = {
			"terminal",
			"help",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
			"dapui_stacks",
			"toggleterm",
			"lazyterm",
			"fzf",
		},
		excluded_filetypes = {
			"terminal",
			"help",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
			"dapui_stacks",
			"toggleterm",
			"lazyterm",
			"fzf",
		},
	},
}