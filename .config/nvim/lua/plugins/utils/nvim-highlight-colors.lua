return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	opts = {
		enable_tailwind = true,
		exclude_buftypes = { "terminal", "snacks_notif" },
		exclude_filetypes = { "lazy", "NeogitCommitView", "snacks_notif", "noice" },
	},
	config = function(_, opts)
		require("nvim-highlight-colors").setup(opts)
	end,
}
