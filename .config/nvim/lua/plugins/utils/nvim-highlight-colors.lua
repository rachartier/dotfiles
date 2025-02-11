return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	opts = {
		enable_tailwind = true,
		exclude_buftypes = { "terminal" },
		exclude_filetypes = { "lazy" },
	},
	config = function(_, opts)
		require("nvim-highlight-colors").setup(opts)
	end,
}
