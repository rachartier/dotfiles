local utils = require("utils")
return {
	{
		"echasnovski/mini.splitjoin",
		version = false,
		event = { "InsertEnter" },
		config = function()
			require("mini.splitjoin").setup({
				-- Module mappings. Use `''` (empty string) to disable one.
				-- Created for both Normal and Visual modes.
				mappings = {
					toggle = "gS",
					split = "",
					join = "",
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		event = "LazyFile",
		config = function()
			require("mini.surround").setup({})
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		enabled = false,
		event = { "LazyFile" },
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
		event = { "LazyFile" },
		config = function()
			require("mini.align").setup()
		end,
	},
	{
		"echasnovski/mini.indentscope",
		event = { "LazyFile" },
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
}
