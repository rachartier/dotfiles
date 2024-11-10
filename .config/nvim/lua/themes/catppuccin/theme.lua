local M = {}

M.flavour = "macchiato"

function M.get_colors()
	return require("catppuccin.palettes").get_palette(M.flavour)
end

function M.get_lualine_colors()
	local c = M.get_colors()

	local lualine_colors = {
		-- bg = "#232639", --c.mantle,
		-- bg = U.lighten(c.base, 0.99),
		-- bg = c.mantle,
		bg = c.surface0,
		fg = c.subtext0,
		surface0 = c.surface0,
		yellow = c.yellow,
		flamingo = c.flamingo,
		cyan = c.sapphire,
		darkblue = c.mantle,
		green = c.green,
		orange = c.peach,
		violet = c.lavender,
		mauve = c.mauve,
		blue = c.blue,
		red = c.red,
	}

	return vim.tbl_extend("force", lualine_colors, c)
end

function M.setup()
	local cached_tmux_theme = require("utils").read_file("/tmp/tmux-theme.cache")
	local theme = M.flavour

	if cached_tmux_theme == "catppuccin_macchiato.conf" then
		theme = "macchiato"
	elseif cached_tmux_theme == "catppuccin_mocha.conf" then
		theme = "mocha"
	elseif cached_tmux_theme == "catppuccin_frappe.conf" then
		theme = "frappe"
	elseif cached_tmux_theme == "catppuccin_latte.conf" then
		theme = "latte"
	end

	M.flavour = theme

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
		flavour = theme, -- latte, frappe, macchiato, mocha
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
				underlines = underlines,
				inlay_hints = {
					background = true,
				},
			},
			-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		},
	})

	vim.cmd.colorscheme("catppuccin")
	vim.cmd([[echo " "]]) -- fix flickering... https://github.com/neovim/neovim/issues/19362

	-- require("themes.groups").override_hl(M.get_colors())
	-- require("themes.groups").override_lsp_hl(M.get_colors())
end

return M
