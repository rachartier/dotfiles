return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	config = function()
		require("nvim-highlight-colors").setup({
			render = "background",
			virtual_symbol_position = "inline",
		})
	end,
}
