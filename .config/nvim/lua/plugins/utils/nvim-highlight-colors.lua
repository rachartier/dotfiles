return {
	-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/nvim-highlight-colors",
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	config = function()
		require("nvim-highlight-colors").setup({
			render = "background",
			virtual_symbol_position = "inline",
			exclude = {
				"alpha",
				"lazy",
				"notify",
			},
		})
	end,
}
