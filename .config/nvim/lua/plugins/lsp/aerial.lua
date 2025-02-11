local open_on_ft = {
	"markdown",
	"yaml",
	"json",
}
return {
	"stevearc/aerial.nvim",
	ft = open_on_ft,
	enabled = true,
	keys = {
		{ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = "LazyFile",
	opts = {
		layout = {
			default_direction = "prefer_left",
			width = 0.4,
		},
		close_automatic_events = {
			"switch_buffer",
		},
		autojump = true,
		attach_mode = "global",

		open_automatic = function(bufnr)
			local aerial = require("aerial")

			local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
			return vim.tbl_contains(open_on_ft, ft) and not aerial.was_closed()
		end,
	},
}
