local border = require("config.ui.border").default_border

return {
	ui_select = true,
	matcher = {
		frecency = true,
	},
	reverse = true,
	formatters = {
		file = {
			filename_first = true,
		},
	},
	layout = {
		cycle = true,
		--- Use the default layout or vertical if the window is too narrow
		preset = function()
			return vim.o.columns >= 130 and "custom" or "vertical"
		end,
	},
	win = {
		input = {
			keys = {
				["<Tab>"] = { "list_down", mode = { "n", "i" } },
				["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
				["<Esc>"] = { "close", mode = { "n", "i" } },
			},
		},
		list = {
			keys = {
				["<Tab>"] = { "list_down", mode = { "n", "i" } },
				["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
			},
		},
	},
	layouts = {
		custom = {
			layout = {
				box = "horizontal",
				backdrop = false,
				width = 0.9,
				height = 0.8,
				border = "none",
				{
					box = "vertical",
					{ win = "list", title = " Results ", title_pos = "center", border = border },
					{
						win = "input",
						height = 1,
						border = border,
						title = "{source} {live}",
						title_pos = "center",
					},
				},
				{
					win = "preview",
					width = 0.60,
					border = border,
					title = " Preview ",
					title_pos = "center",
				},
			},
		},
		vertical = {
			layout = {
				backdrop = false,
				width = 0.5,
				min_width = 80,
				height = 0.8,
				min_height = 30,
				box = "vertical",
				border = border,
				title_pos = "center",
				{ win = "preview", height = 0.4, border = "none" },
				{ win = "list", border = "top" },
				{ win = "input", height = 1, border = "top" },
			},
		},
	},
}
