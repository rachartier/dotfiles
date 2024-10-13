local utils = require("utils")

return {
	{
		"echasnovski/mini.splitjoin",
		version = false,
		event = { "InsertEnter" },
		opts = {
			-- Module mappings. Use `''` (empty string) to disable one.
			-- Created for both Normal and Visual modes.
			mappings = {
				toggle = "gS",
				split = "",
				join = "",
			},
		},
	},
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.hipatterns",
		enabled = true,
		event = { "VeryLazy" },
		config = function()
			local hipatterns = require("mini.hipatterns")

			hipatterns.setup({
				highlighters = {
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
	{
		"echasnovski/mini.align",
		event = { "VeryLazy" },
		opts = {},
	},
	{
		"echasnovski/mini.indentscope",
		event = { "VeryLazy" },
		init = function()
			utils.on_event("FileType", function()
				---@diagnostic disable-next-line: inject-field
				vim.b.miniindentscope_disable = true
			end, {
				target = {
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
					"spectre_panel",
				},
				desc = "Disable mini.indentscope",
			})
		end,
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
				options = {
					indent_at_cursor = true,
					try_as_border = true,
					border = "top",
				},
				symbol = "╎",
			})
		end,
	},
	{
		"echasnovski/mini.cursorword",
		event = { "VeryLazy" },
		version = false,
		opts = {},
	},
}
