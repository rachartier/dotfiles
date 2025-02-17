return {
	enabled = true,
	preset = {
		---@type snacks.dashboard.Item[]|fun(items:snacks.dashboard.Item[]):snacks.dashboard.Item[]?
		keys = {
			{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
			{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
			{
				icon = " ",
				key = "g",
				desc = "Find Text",
				action = ":lua Snacks.dashboard.pick('live_grep')",
			},
			{
				icon = " ",
				key = "r",
				desc = "Recent Files",
				action = ":lua Snacks.dashboard.pick('oldfiles')",
			},
			{
				icon = " ",
				key = "c",
				desc = "Config",
				action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
			},
			{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
			{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
			{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
		},

		-- 				header = [[
		-- ███┐   ██┐███████┐ ██████┐ ██┐   ██┐██┐███┐   ███┐
		-- ████┐  ██│██┌────┘██┌───██┐██│   ██│██│████┐ ████│
		-- ██┌██┐ ██│█████┐  ██│   ██│██│   ██│██│██┌████┌██│
		-- ██│└██┐██│██┌──┘  ██│   ██│└██┐ ██┌┘██│██│└██┌┘██│
		-- ██│ └████│███████┐└██████┌┘ └████┌┘ ██│██│ └─┘ ██│
		-- └─┘  └───┘└──────┘ └─────┘   └───┘  └─┘└─┘     └─┘
		-- ]],
		-- 				-- 				header = [[
		-- 				--  __    __ ________  ______  __     __ ______ __       __
		-- 				-- |  \  |  \        \/      \|  \   |  \      \  \     /  \
		-- 				-- | ▓▓\ | ▓▓ ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓
		-- 				-- | ▓▓▓\| ▓▓ ▓▓__   | ▓▓  | ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓
		-- 				-- | ▓▓▓▓\ ▓▓ ▓▓  \  | ▓▓  | ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓
		-- 				-- | ▓▓\▓▓ ▓▓ ▓▓▓▓▓  | ▓▓  | ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓
		-- 				-- | ▓▓ \▓▓▓▓ ▓▓_____| ▓▓__/ ▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓
		-- 				-- | ▓▓  \▓▓▓ ▓▓     \\▓▓    ▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓
		-- 				--  \▓▓   \▓▓\▓▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓▓▓▓▓\▓▓      \▓▓
		-- 				-- ]],
		-- 				-- 				header = [[
		-- 				-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
		-- 				-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
		-- 				-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
		-- 				-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
		-- 				-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
		-- 				-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
		-- 				-- ]],
		header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⢤⠶⠶⠶⢦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣀⡤⠴⠶⢤⣄⡀⠀⠀⠀⢀⣤⠶⠛⠋⣁⣀⣤⣤⣤⣤⣤⣤⣤⣀⣈⠉⠛⠳⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣠⠞⢁⣠⣤⣤⣤⣀⠙⠲⣤⠖⠋⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡈⠓⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢰⠃⢠⣿⣿⣿⣿⣿⣿⣷⡦⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⡏⠀⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀
⡇⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢱⣶⡎⢿⣿⣿⣿⣿⢣⣾⣆⢻⣿⣿⣿⣿⣿⣿⣿⣿⣆⠈⢦⡀⠀⠀⠀⠀⠀⠀
⣷⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⡇⢸⣿⣿⣿⡏⢸⣿⡟⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠈⢧⠀⠀⠀⠀⠀⠀
⢹⡆⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠉⠀⢸⣿⣿⣿⡇⠀⠉⠁⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠘⡇⠀⠀⠀⠀⠀
⠀⢿⡄⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⢸⣿⣿⣿⣇⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠹⣆⠀⠀⠀⠀
⠀⠀⠙⣆⠈⢋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⣾⣿⣿⣿⣿⡀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠈⢦⠀⠀⠀
⠀⠀⠀⢸⡇⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣾⡟⠉⠉⠉⠙⣷⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠈⢧⡀⠀
⠀⠀⠀⠘⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠰⣿⡷⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠸⡇⠀
⠀⠀⠀⠀⣧⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⠀
⠀⠀⠀⠀⢻⡆⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢠⡿⠀
⠀⠀⠀⠀⠈⣿⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠻⣿⣿⣿⠿⠋⢀⡞⠁⠀
⠀⠀⠀⠀⠀⣸⠇⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠗⠀⠀⢤⣤⠶⠋⠀⠀⠀
⠀⠀⢀⡴⠋⠀⣴⣾⣦⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣰⣷⣦⣄⠉⠳⣄⠀⠀⠀
⠀⡴⠋⠀⠐⠋⢹⣿⣿⣿⣦⡙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣾⣿⣿⡏⠉⠓⠄⠈⢧⡀⠀
⣼⠁⣰⡇⠀⣀⣼⣿⣿⣿⣿⣿⣦⣌⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣉⣴⣿⣿⣿⣿⣿⣷⣄⡀⢀⣆⠀⢧⠀
⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣍⡙⠛⠛⠿⠿⣿⡿⠿⠟⠛⠛⣉⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠆⢸⡆
⠻⣄⠈⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠟⠓⠀⣠⣤⣄⠀⠐⠚⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⢀⡼⠁
⠀⠈⠛⠶⣤⣤⣀⣀⣉⣉⣉⣉⣉⣀⣀⣀⣠⣤⣤⠴⠖⠋⠁⠀⠈⠙⠲⠶⣤⣤⣄⣀⣀⣀⣉⣉⣉⣉⣉⣁⣀⣤⣤⠴⠞⠋⠀⠀
]],
	},
	formats = {
		terminal = { align = "center" },
		version = { "%s", align = "center" },
	},

	sections = {
		-- { section = "header", height = 14, width = 10 },

		{
			section = "terminal",
			-- cmd = 'timg --loops=-1 -V -g 32x32 "$HOME/.config/nvim/dashboard/gif/kirby-dancing2.gif"',
			cmd = 'chafa --speed=0.9 --clear --passthrough=tmux --scale max "$HOME/.config/nvim/dashboard/gif/kirby-dancing2.gif"',
			indent = 8,
			ttl = 0,
			enabled = function()
				return vim.fn.executable("chafa") == 1
			end,
			height = 24,
		},
		{ section = "keys", gap = 1, padding = 1 },
		{ section = "startup" },

		function()
			local in_git = Snacks.git.get_root() ~= nil
			local cmds = {
				{
					title = "Git Graph",
					icon = " ",
					cmd = [[echo -e "$(git-graph --style round --color always --wrap 50 0 8 -f 'oneline')"]],
					indent = 1,
					height = 39,
				},
				-- {
				-- 	icon = " ",
				-- 	title = "Git Status",
				-- 	cmd = "git diff --stat -B -M -C",
				-- 	indent = 3,
				-- },
			}
			return vim.tbl_map(function(cmd)
				return vim.tbl_extend("force", {
					pane = 2,
					section = "terminal",
					enabled = function()
						return in_git and vim.o.columns > 130
					end,
					padding = 1,
					-- ttl = 5 * 60,
				}, cmd)
			end, cmds)
		end,
	},
}
