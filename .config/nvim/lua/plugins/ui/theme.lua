return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		enabled = true,
		opts = {
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.35,
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
