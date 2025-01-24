return {
	"stevearc/oil.nvim",
	keys = {
		{
			"<leader>te",
			"<Cmd>Oil --float<CR>",
			desc = "Open Oil",
		},
	},
	opts = {
		watch_for_changes = true,
		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtime",
		},
		float = {
			get_win_title = nil,
			preview_split = "right",
			border = require("config.ui.border").default_border,

			max_width = 0.40,
			max_height = 0.80,

			override = function(conf)
				return conf
			end,
		},
		keymaps = {
			["<BS>"] = { "actions.parent", mode = "n" },
		},
	},
}
