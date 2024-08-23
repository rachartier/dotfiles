return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	enabled = true,
	opts = {
		render = "background",
		virtual_symbol_position = "inline",
		exclude_filetypes = {
			"alpha",
			"lazy",
			"notify",
		},
		exclude_buftypes = {},
	},
}
