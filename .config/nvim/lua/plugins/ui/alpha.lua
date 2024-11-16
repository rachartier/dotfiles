local utils = require("utils")
local config = require("config")

local version = vim.version()

local function build_layout(opts)
	local header_padding = opts.header_padding or 0
	local header = opts.header or {}
	local buttons = opts.buttons or {}
	local footer = opts.footer or {}

	local version_str = " v"
		.. version.major
		.. "."
		.. version.minor
		.. "."
		.. version.patch
		.. " ("
		.. version.build
		.. ")"

	return {
		{ type = "padding", val = header_padding },
		header,
		{
			type = "text",
			val = {
				version_str,
			},
			opts = {
				position = "center",
				hl = "Type",
				-- wrap = "overflow";
			},
		},
		{ type = "padding", val = 2 },
		buttons,
		{ type = "padding", val = 1 },
		footer,
	}
end

local function get_heading_padding(margin)
	local win_height = vim.api.nvim_win_get_height(0)
	-- local margin_top_percent = margin or 0.25
	local margin_top_percent = margin or 0.15

	if win_height <= 32 then
		margin_top_percent = 0
	end

	return vim.fn.max({ 0, vim.fn.floor(vim.fn.winheight(0) * margin_top_percent) })
end

return {
	"goolord/alpha-nvim",
	init = false,
	lazy = false,
	enabled = true,
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		local header = {}

		if config.gif_alpha_enabled and vim.fn.executable("chafa") == 1 then
			header = {
				type = "terminal",
				command = "chafa $HOME/.config/nvim/dashboard/gif/kirby-dancing.gif",
				width = 24 * 2,
				height = 24 * 2,
				opts = {
					redraw = false,
					position = "center",
				},
			}
		elseif config.tty_clock_alpha_enabled and vim.fn.executable("tty-clock") == 1 then
			header = {
				type = "terminal",
				command = "tty-clock -s -c -b -C 4",
				-- command = "clock-rs clock",
				width = 60,
				height = 11,
				opts = {
					redraw = true,
					position = "center",
				},
			}
		else
			header = {
				type = "text",
				opts = {
					position = "center",
					hl = "AlphaHeader",

					-- wrap = "overflow";
				},
				val = {
					-- [[         ,--.              ,----..                                 ____  ]],
					-- [[       ,--.'|    ,---,.   /   /   \                 ,---,        ,'  , `.]],
					-- [[   ,--,:  : |  ,'  .' |  /   .     :        ,---.,`--.' |     ,-+-,.' _ |]],
					-- [[,`--.'`|  ' :,---.'   | .   /   ;.  \      /__./||   :  :  ,-+-. ;   , ||]],
					-- [[|   :  :  | ||   |   .'.   ;   /  ` ; ,---.;  ; |:   |  ' ,--.'|'   |  ;|]],
					-- [[:   |   \ | ::   :  |-,;   |  ; \ ; |/___/ \  | ||   :  ||   |  ,', |  ':]],
					-- [[|   : '  '; |:   |  ;/||   :  | ; | '\   ;  \ ' |'   '  ;|   | /  | |  ||]],
					-- [['   ' ;.    ;|   :   .'.   |  ' ' ' : \   \  \: ||   |  |'   | :  | :  |,]],
					-- [[|   | | \   ||   |  |-,'   ;  \; /  |  ;   \  ' .'   :  ;;   . |  ; |--' ]],
					-- [['   : |  ; .''   :  ;/| \   \  ',  /    \   \   '|   |  '|   : |  | ,    ]],
					-- [[|   | '`--'  |   |    \  ;   :    /      \   `  ;'   :  ||   : '  |/     ]],
					-- [['   : |      |   :   .'   \   \ .'        :   \ |;   |.' ;   | |`-'      ]],
					-- [[;   |.'      |   | ,'      `---`           '---" '---'   |   ;/          ]],
					-- [['---'        `----'                                      '---'           ]],
					-- [[                                                                         ]],
					--
					-- [[     ___           ___           ___           ___                       ___     ]],
					-- [[    /\__\         /\  \         /\  \         /\__\          ___        /\__\    ]],
					-- [[   /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |   ]],
					-- [[  /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |   ]],
					-- [[ /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__ ]],
					-- [[/:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\]],
					-- [[\/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /]],
					-- [[    |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  / ]],
					-- [[    |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /  ]],
					-- [[    /:/  /       \:\__\        \::/  /       ~~~~         \/__/         /:/  /   ]],
					-- [[    \/__/         \/__/         \/__/                                   \/__/    ]],
					-- [[ 																				   ]],
					-- [[ 																				   ]],
					-- [[ 																				   ]],
					--
					-- [[                               __                ]],
					-- [[  ___      __    ___   __  __ /\_\    ___ ___    ]],
					-- [[/' _ `\  /'__`\ / __`\/\ \/\ \\/\ \ /' __` __`\  ]],
					-- [[/\ \/\ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
					-- [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
					-- [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
					-- [[                                                 ]],
					--
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⣠⡶⠒⠒⠶⣄⣠⡴⠚⠁⠀⠀⠀⠀⠀⠉⠙⠳⢦⠀⠀⠀⠀⠀⠀]],
					[[⢠⡏⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⡀⠀⠀⠀⠀]],
					[[⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠋⢱⠀⠀⢠⠉⢡⠀⠀⠀⠀⠻⡄⠀⠀⠀]],
					[[⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⣧⣾⠄⠀⢸⣦⣾⠀⠀⠀⠀⠀⢻⡄⠀⠀]],
					[[⠀⠘⢧⡀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠸⣿⡿⠀⠀⠀⠀⠀⠈⠳⣄⠀]],
					[[⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠈⠁⡴⠶⡆⠉⠁⠀⠀⠀⠀⠀⠀⠀⠹⡄]],
					[[⠀⠀⠀⢷⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷]],
					[[⠀⠀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠇]],
					[[⠀⠀⠀⣀⡿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡽⣿⡛⠁⠀]],
					[[⠀⣠⢾⣭⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⠀⢠⣝⣷⡀]],
					[[⢠⡏⠘⠋⠀⠀⠀⠈⠑⠦⣀⠀⠀⠀⠀⠀⣀⡠⠔⠋⠀⠀⠈⠛⠃⢻]],
					[[⠈⠷⣤⣀⣀⣀⣀⣀⣀⣀⣤⡽⠟⠛⠿⣭⣄⣀⣀⣀⣀⣀⣀⣀⣤⠞]],
					[[⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠀⠀⠀]],
					[[⠀⠀⠀⠀                      ]],
					-- [[ ███       ███ ]],
					-- [[████      ████]],
					-- [[██████     █████]],
					-- [[███████    █████]],
					-- [[████████   █████]],
					-- [[█████████  █████]],
					-- [[█████ ████ █████]],
					-- [[█████  █████████]],
					-- [[█████   ████████]],
					-- [[█████    ███████]],
					-- [[█████     ██████]],
					-- [[████      ████]],
					-- [[ ███       ███ ]],
					-- [[                  ]],
					-- [[ N  E  O  V  I  M ]],
					-- --
					-- [[    ___       ___       ___       ___       ___       ___    ]],
					-- [[   /\__\     /\  \     /\  \     /\__\     /\  \     /\__\   ]],
					-- [[  /:| _|_   /::\  \   /::\  \   /:/ _/_   _\:\  \   /::L_L_  ]],
					-- [[ /::|/\__\ /::\:\__\ /:/\:\__\ |::L/\__\ /\/::\__\ /:/L:\__\ ]],
					-- [[ \/|::/  / \:\:\/  / \:\/:/  / |::::/  / \::/\/__/ \/_/:/  / ]],
					-- [[   |:/  /   \:\/  /   \::/  /   L;;/__/   \:\__\     /:/  /  ]],
					-- [[   \/__/     \/__/     \/__/               \/__/     \/__/   ]],
					-- [[   														   ]],
					-- [[   														   ]],
					-- [[   														   ]],
					-- [[                                                                       ]],
					-- [[                                                                     ]],
					-- [[       ████ ██████           █████      ██                     ]],
					-- [[      ███████████             █████                             ]],
					-- [[      █████████ ███████████████████ ███   ███████████   ]],
					-- [[     █████████  ███    █████████████ █████ ██████████████   ]],
					-- [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
					-- [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
					-- [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
					-- [[                                                                       ]],
				},
			}
		end

		-- header.val[#header.val] = string.rep(" ", #header.val[#header.val] / 2 - #version_str / 2 - 2) .. version_str
		--
		-- dashboard.section.footer = {
		-- 	type = "text",
		-- 	opts = {
		-- 		position = "center",
		-- 		hl = "@constant.builtin",
		-- 		-- wrap = "overflow";
		-- 	},
		-- 	val = {
		-- 		"",
		-- 	},
		-- }
		--
		dashboard.section.buttons.val = {
			dashboard.button("    e    ", "󰈔  New file", "<cmd>ene<CR>"),
			dashboard.button(" SPC f f ", "  Find file"),
			dashboard.button(" SPC f g ", "󰺮  Live grep"),
			dashboard.button("    c    ", "  Configuration", "<cmd>cd ~/.config/nvim/ | e init.lua<CR>"),
			dashboard.button("    l    ", "  Open Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("    q    ", "󰩈  Quit", "<cmd>qa<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		local header_padding = get_heading_padding()

		dashboard.opts.layout = build_layout({
			header_padding = header_padding,
			header = header,
			buttons = dashboard.section.buttons,
			footer = dashboard.section.footer,
		})
		--
		-- utils.on_event("VimResized", function()
		-- 	if vim.bo.filetype == "alpha" then
		-- 		header_padding = get_heading_padding()
		--
		-- 		dashboard.opts.layout = build_layout({
		-- 			header_padding = header_padding,
		-- 			header = header,
		-- 			buttons = dashboard.section.buttons,
		-- 			footer = dashboard.section.footer,
		-- 		})
		--
		-- 		pcall(vim.cmd.AlphaRedraw)
		-- 	end
		-- end, { desc = "Redraw alpha on resize" })

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			desc = "Add Alpha dashboard footer",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

				dashboard.opts.layout = build_layout({
					header_padding = header_padding,
					header = header,
					buttons = dashboard.section.buttons,
					footer = dashboard.section.footer,
				})

				local footer_txt = "   Loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. " ms"

				dashboard.section.footer.val = {
					-- string.rep("─", #footer_txt - 1),
					footer_txt,
					-- string.rep("─", #footer_txt - 1),
				}

				-- pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		local alpha = require("alpha")
		if config.gif_alpha_enabled or config.tty_clock_alpha_enabled then
			require("alpha.term")
		end

		dashboard.opts.config = {
			noautocmd = true,
			redraw_on_resize = true,
		}

		alpha.setup(dashboard.opts)
	end,
}
