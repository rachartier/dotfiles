local utils = require("utils")

local function build_layout(opts)
	local header_padding = opts.header_padding or 0
	local header = opts.header or {}
	local buttons = opts.buttons or {}
	local footer = opts.footer or {}

	return {
		{ type = "padding", val = header_padding },
		header,
		{
			type = "text",
			val = {
				"Neovim " .. string.format("%s", vim.version()),
			},
			opts = {
				position = "center",
				hl = "Type",
				-- wrap = "overflow";
			},
		},
		{ type = "padding", val = 2 },
		buttons,
		footer,
	}
end

local function get_heading_padding(margin)
	local win_height = vim.api.nvim_win_get_height(0)
	local margin_top_percent = margin or 0.25

	if win_height <= 30 then
		margin_top_percent = 0
	end

	return vim.fn.max({ 0, vim.fn.floor(vim.fn.winheight(0) * margin_top_percent) })
end

return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		require("alpha.term")
		local dashboard = require("alpha.themes.dashboard")

		local header = {}

		-- if true then
		-- 	header = {
		-- 		type = "text",
		-- 		opts = {
		-- 			position = "center",
		-- 			hl = "GitSignsChange",
		-- 			-- wrap = "overflow";
		-- 		},
		-- 		val = {
		--
		-- 			[[                  ...                  ]],
		-- 			[[                  ^""`                 ]],
		-- 			[[          ... ... '``'                 ]],
		-- 			[[         `"""."""'^""`       .'        ]],
		-- 			[[         '```.```.'``'       """'      ]],
		-- 			[[     """``"""."""'^""`'""". .""""```'. ]],
		-- 			[[     ''''''''.'''.''''.'''. .^""""""". ]],
		-- 			[[  ^"""""""""""""""""""""""""""""`''.   ]],
		-- 			[[  ^""""""""""""""""""""""""""""'       ]],
		-- 			[[  .""""""""""""""""""""""""""".        ]],
		-- 			[[   '""""""""""""""""""""""""`          ]],
		-- 			[[    .^"""""""""""""""""""`'            ]],
		-- 			[[      .'`"""""""""""^`'.               ]],
		-- 			[[           .......                     ]],
		-- 			[[                                       ]],
		-- 		},
		-- 	}
		if vim.fn.executable("chafa") == 1 and require("config").gif_alpha_enabled and vim.g.neovide == 0 then
			header = {
				type = "terminal",
				command = "chafa $HOME/.config/nvim/dashboard/gif/kirby-dancing.gif",
				width = 24,
				height = 12,
				opts = {
					redraw = true,
					window_config = {},
					position = "center",
				},
			}
		elseif vim.fn.executable("tty-clock") == 1 and require("config").tty_clock_alpha_enabled == true then
			header = {
				type = "terminal",
				command = "tty-clock -s -c -b -C 4",
				width = 60,
				height = 12,
				opts = {
					redraw = true,
					window_config = {},
					position = "center",
				},
			}
		else
			header = {
				type = "text",
				opts = {
					position = "center",
					hl = "Type",
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
					--
					-- [[    ___       ___       ___       ___       ___       ___    ]],
					-- [[   /\__\     /\  \     /\  \     /\__\     /\  \     /\__\   ]],
					-- [[  /:| _|_   /::\  \   /::\  \   /:/ _/_   _\:\  \   /::L_L_  ]],
					-- [[ /::|/\__\ /::\:\__\ /:/\:\__\ |::L/\__\ /\/::\__\ /:/L:\__\ ]],
					-- [[ \/|::/  / \:\:\/  / \:\/:/  / |::::/  / \::/\/__/ \/_/:/  / ]],
					-- [[   |:/  /   \:\/  /   \::/  /   L;;/__/   \:\__\     /:/  /  ]],
					-- [[   \/__/     \/__/     \/__/               \/__/     \/__/   ]],
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
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			desc = "Add Alpha dashboard footer",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100

				dashboard.section.footer.val = {
					" ",
					" ",
					"Loaded " .. stats.loaded .. " plugins (" .. stats.count .. " total)   in " .. ms .. "ms",
				}

				-- pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- dashboard.section.header.val = {

		-- }

		dashboard.section.buttons.val = {
			dashboard.button("e", "󰈔  New file", "<cmd>ene<CR>"),
			dashboard.button("SPC f f", "󰱼  Find file"),
			dashboard.button("SPC f g", "󰺮  Live grep"),
			dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ | e init.lua<CR>"),
			dashboard.button("l", "  Open Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("q", "󰩈  Quit", "<cmd>qa<CR>"),
		}

		local header_padding = get_heading_padding()

		dashboard.config.layout = build_layout({
			header_padding = header_padding,
			header = header,
			buttons = dashboard.section.buttons,
			footer = dashboard.section.footer,
		})

		alpha.setup(dashboard.config)

		utils.on_event("VimResized", function()
			if vim.bo.filetype == "alpha" then
				header_padding = get_heading_padding()

				dashboard.config.layout = build_layout({
					header_padding = header_padding,
					header = header,
					buttons = dashboard.section.buttons,
					footer = dashboard.section.footer,
				})

				pcall(vim.cmd.AlphaRedraw)
			end
		end, { desc = "Redraw alpha on resize" })

		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt.laststatus = 0
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaClosed",
			callback = function()
				vim.opt.laststatus = 3
			end,
		})
	end,
}
