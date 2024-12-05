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
		enabled = false,
		event = { "VeryLazy" },
		config = function()
			local hi = require("mini.hipatterns")
			return {
				tailwind = {
					enabled = true,
					ft = {
						"astro",
						"css",
						"heex",
						"html",
						"html-eex",
						"javascript",
						"javascriptreact",
						"rust",
						"svelte",
						"typescript",
						"typescriptreact",
						"vue",
					},
					-- full: the whole css class will be highlighted
					-- compact: only the color will be highlighted
					style = "full",
				},
				highlighters = {
					hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
					shorthand = {
						pattern = "()#%x%x%x()%f[^%x%w]",
						group = function(_, _, data)
							---@type string
							local match = data.full_match
							local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
							local hex_color = "#" .. r .. r .. g .. g .. b .. b

							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},
				},
			}
		end,
	},
	{
		"echasnovski/mini.align",
		event = { "VeryLazy" },
		opts = {},
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
					"spectre_panel",
					"snacks_dashoard",
					"snacks_notif",
					"snacks_terminal",
					"snacks_win",
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
				symbol = "┆",
			})
		end,
	},
	{
		"echasnovski/mini.cursorword",
		event = { "CursorMoved" },
		version = false,
		enabled = false,
		opts = {
			delay = 0,
		},
	},
	-- {
	-- 	"echasnovski/mini.animate",
	-- 	event = { "VeryLazy" },
	-- 	opts = function(_, opts)
	-- 		local animate = require("mini.animate")
	--
	-- 		return {
	-- 			scroll = {
	-- 				timing = animate.gen_timing.linear({ duration = 140, unit = "total" }),
	-- 			},
	-- 			open = { enabled = false },
	-- 			close = { enabled = false },
	-- 		}
	-- 	end,
	-- },
}
