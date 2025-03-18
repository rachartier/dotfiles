return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		enabled = true,
		opts = {
			flavour = "latte", -- latte, frappe, macchiato, mocha
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.35,
			},
			color_overrides = {
				latte = {
					rosewater = "#a43b35",
					flamingo = "#da3537",
					pink = "#d332a1",
					mauve = "#aa3685",
					red = "#ff3532",
					maroon = "#de3631",
					peach = "#f36c0b",
					yellow = "#bd8800",
					green = "#596600",
					teal = "#287e5e",
					sky = "#52b1c7",
					sapphire = "#3fb4b8",
					blue = "#317da7",
					lavender = "#474155",
					text = "#4d4742",
					subtext1 = "#5b5549",
					subtext0 = "#6d6655",
					overlay2 = "#786d5a",
					overlay1 = "#8c7c62",
					overlay0 = "#a18d66",
					surface2 = "#c9bea5",
					surface1 = "#d8d3ba",
					surface0 = "#e8e2c8",
					base = "#ebe4c8",
					mantle = "#e1dab5",
					crust = "#bdc0a0",
				},
			},
			highlight_overrides = {
				all = function(colors)
					return require("themes.groups").get(colors)
				end,
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			styles = {
				comments = { "italic" },
				conditionals = {},
				-- loops = {},
				-- functions = {},
				-- keywords = { "bold" },
				-- strings = {},
				-- variables = {},
				-- numbers = {},
				-- booleans = {},
				-- properties = {},
				types = {},
				operators = {},
			},
			integrations = {
				aerial = true,
				alpha = true,
				blink_cmp = true,
				cmp = false,
				dap = true,
				dap_ui = true,
				diffview = true,
				gitsigns = true,
				lsp_trouble = false,
				mason = true,
				mini = true,
				neotree = true,
				noice = true,
				notify = true,
				render_markdown = true,
				symbols_outline = true,
				telekasten = true,
				telescope = true,
				treesitter = true,
				treesitter_context = false,
				which_key = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
					inlay_hints = {
						background = true,
					},
				},
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
