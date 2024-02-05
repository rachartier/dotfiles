local M = {}
local U = require("utils")
local flavour = "macchiato"

function M.get_colors()
	return require("catppuccin.palettes").get_palette(flavour)
end

function M.get_lualine_colors()
	local c = M.get_colors()

	return {
		-- bg = "#232639", --c.mantle,
		-- bg = U.lighten(c.base, 0.99),
		bg = c.mantle,
		fg = c.subtext0,
		yellow = c.yellow,
		cyan = c.cyan,
		darkblue = c.mantle,
		green = c.green,
		orange = c.peach,
		violet = c.lavender,
		mauve = c.mauve,
		blue = c.blue,
		red = c.red,
	}
end

function M.setup()
	local underlines = {

		errors = { "undercurl" },
		hints = { "undercurl" },
		warnings = { "undercurl" },
		information = { "undercurl" },
	}
	if vim.g.neovide then
		underlines = {
			errors = { "undercurl" },
			hints = { "undercurl" },
			warnings = { "undercurl" },
			information = { "undercurl" },
		}
	end
	require("catppuccin").setup({
		lazy = true,
		flavour = flavour, -- latte, frappe, macchiato, mocha
		transparent_background = false,
		show_end_of_buffer = false,
		term_colors = true,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.65,
		},
		no_italic = false, -- Force no italic
		no_bold = false, -- Force no bold
		styles = {
			comments = { "italic" },
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {
			all = {
				-- base = "#16161D",
			},
		},
		highlight_overrides = {
			all = function(colors)
				return require("themes.groups").get(colors)
			end,
		},
		integrations = {
			alpha = true,
			cmp = true,
			dap = true,
			dap_ui = true,
			gitsigns = true,
			-- harpoon = true,
			-- illuminate = true,
			lsp_trouble = true,
			mason = true,
			mini = true,
			neotree = true,
			noice = true,
			notify = true,
			telekasten = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = underlines,
				inlay_hints = {
					background = true,
				},
			},
			-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		},
	})

	vim.cmd.colorscheme("catppuccin")

	require("themes.groups").override_hl(M.get_colors())
	require("themes.groups").override_lsp_hl(M.get_colors())
end

return M
