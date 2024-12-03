local signs = require("config.ui.signs").full_diagnostic

local M = {}

local function startup()
	M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats or require("lazy.stats").stats()
	local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
	return {
		align = "center",
		text = {
			{ "  Loaded ", hl = "footer" },
			{ M.lazy_stats.loaded .. "/" .. M.lazy_stats.count, hl = "special" },
			{ " plugins in ", hl = "footer" },
			{ ms .. "ms", hl = "special" },
		},
	}
end

return {
	-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/snacks.nvim",
	"folke/snacks.nvim",
	priority = 9999,
	lazy = false,
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>ps",
			function()
				Snacks.profiler.scratch()
			end,
			desc = "Profiler Scratch Buffer",
		},
	},
	opts = {
		styles = {
			dashboard = {
				wo = {
					winblend = 0,
				},
			},
			notification = {
				border = require("config.ui.border").default_border,
				wo = {
					wrap = true,
					winblend = 0,
				},
			},
		},
		-- statuscol = {
		-- 	left = { "mark", "sign" },
		-- 	right = { "git" },
		-- 	folds = {
		-- 		open = false, -- show open fold icons
		-- 		git_hl = false, -- use Git Signs hl for fold icons
		-- 	},
		-- 	git = {
		-- 		patterns = { "GitSign", "MiniDiffSign" },
		-- 	},
		-- 	refresh = 50,
		-- },
		notifier = {
			enabled = true,
			icons = {
				error = signs.error,
				warn = signs.warning,
				info = signs.info,
				trace = signs.hint,
			},
		},
		dashboard = {
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

				header = [[
███┐   ██┐███████┐ ██████┐ ██┐   ██┐██┐███┐   ███┐
████┐  ██│██┌────┘██┌───██┐██│   ██│██│████┐ ████│
██┌██┐ ██│█████┐  ██│   ██│██│   ██│██│██┌████┌██│
██│└██┐██│██┌──┘  ██│   ██│└██┐ ██┌┘██│██│└██┌┘██│
██│ └████│███████┐└██████┌┘ └████┌┘ ██│██│ └─┘ ██│
└─┘  └───┘└──────┘ └─────┘   └───┘  └─┘└─┘     └─┘
]],
				-- 				header = [[
				--  __    __ ________  ______  __     __ ______ __       __
				-- |  \  |  \        \/      \|  \   |  \      \  \     /  \
				-- | ▓▓\ | ▓▓ ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓
				-- | ▓▓▓\| ▓▓ ▓▓__   | ▓▓  | ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓
				-- | ▓▓▓▓\ ▓▓ ▓▓  \  | ▓▓  | ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓
				-- | ▓▓\▓▓ ▓▓ ▓▓▓▓▓  | ▓▓  | ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓
				-- | ▓▓ \▓▓▓▓ ▓▓_____| ▓▓__/ ▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓
				-- | ▓▓  \▓▓▓ ▓▓     \\▓▓    ▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓
				--  \▓▓   \▓▓\▓▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓▓▓▓▓\▓▓      \▓▓
				-- ]],
				-- 				header = [[
				-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
				-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
				-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
				-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
				-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
				-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
				-- ]],
			},
			formats = {
				terminal = { align = "center" },
			},

			sections = {
				{ section = "header" },
				-- {
				-- 	section = "terminal",
				-- 	cmd = "tty-clock -s -b -C 4",
				-- 	indent = 2,
				-- 	-- height = 12,
				-- },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		notify = { enabled = true },
		toggle = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		words = { enabled = false, debounce = 10 },
		-- statuscolumn = { enabled = true },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command
			end,
		})
	end,
	config = function(_, opts)
		Snacks.dashboard.sections.startup = startup
		require("snacks").setup(opts)

		Snacks.toggle.profiler():map("<leader>pp")
		Snacks.toggle.profiler_highlights():map("<leader>ph")

		if vim.env.PROF then
			local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
			vim.opt.rtp:append(snacks)
			require("snacks.profiler").startup({
				startup = {
					-- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
					-- event = "UIEnter",
					event = "LspAttach",
				},
			})
		end
	end,
}
