return {
	{

		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/nvim-highlight-colors",
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		enabled = true,
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				virtual_symbol_position = "inline",
				exclude_filetypes = {
					"alpha",
					"lazy",
					"notify",
				},
				exclude_buftypes = {},
			})
		end,
	},
}
