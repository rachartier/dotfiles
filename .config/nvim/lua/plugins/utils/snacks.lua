local signs = require("config.ui.signs").full_diagnostic
local border = require("config.ui.border").default_border

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
	"folke/snacks.nvim",
	priority = 9999,
	lazy = false,
    -- stylua: ignore start
	keys = {
		{"<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer",},
		{"<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer",},
		{"<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer",},
		{"<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browser",},
        { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        { "<leader>fd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "<leader>fr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "<leader>fI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "<leader>gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<Tab>", function() Snacks.picker.buffers({
            sort_lastused = true,
            current = false,
        }) end, desc = "Find Git Files" },
	},
	-- stylua: ignore end
	opts = {
		styles = {
			dashboard = {
				wo = {
					winblend = require("config").winblend,
				},
			},
			notification = {
				border = require("config.ui.border").default_border,
				wo = {
					wrap = true,
					winblend = require("config").winblend,
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
				-- 	pane = 2,
				-- 	section = "terminal",
				-- 	cmd = "tty-clock -s -b -C 4",
				-- 	indent = 2,
				-- 	enabled = function()
				-- 		return vim.fn.executable("tty-clock") == 1 and vim.o.columns > 130
				-- 	end,
				-- 	-- height = 12,
				-- },
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
							height = 15,
						},
						{
							icon = " ",
							title = "Git Status",
							cmd = "git diff --stat -B -M -C",
							indent = 3,
						},
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
		},
		-- animate = {},
		-- scroll = {
		-- 	animate = {
		-- 		duration = { step = 15, total = 140 },
		-- 		easing = "inOutQuad",
		-- 	},
		-- },
		indent = {
			animate = {
				enabled = false,
			},
			indent = {
				char = " ",
			},
			scope = {
				char = "┆",
			},
		},
		picker = {
			reverse = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			layout = {
				cycle = true,
				--- Use the default layout or vertical if the window is too narrow
				preset = function()
					return vim.o.columns >= 130 and "custom" or "vertical"
				end,
			},
			win = {
				input = {
					keys = {
						["<Tab>"] = { "list_down", mode = { "n", "i" } },
						["<S-Tab>"] = "list_up",
					},
				},
				list = {
					keys = {
						["<Tab>"] = { "list_down", mode = { "n", "i" } },
						["<S-Tab>"] = "list_up",
					},
				},
			},
			layouts = {
				custom = {
					layout = {
						box = "horizontal",
						backdrop = false,
						width = 0.6,
						height = 0.7,
						border = "none",
						{
							box = "vertical",
							{ win = "list", title = " Results ", title_pos = "center", border = border },
							{
								win = "input",
								height = 1,
								border = border,
								title = "{source} {live}",
								title_pos = "center",
							},
						},
						{
							win = "preview",
							width = 0.45,
							border = border,
							title = " Preview ",
							title_pos = "center",
						},
					},
				},
				vertical = {
					layout = {
						backdrop = false,
						width = 0.5,
						min_width = 80,
						height = 0.8,
						min_height = 30,
						box = "vertical",
						border = border,
						title_pos = "center",
						{ win = "preview", height = 0.4, border = "none" },
						{ win = "list", border = "top" },
						{ win = "input", height = 1, border = "top" },
					},
				},
			},
		},
		input = {},
		gitbrowse = {},
		notify = {},
		toggle = {},
		bigfile = {},
		quickfile = {},
		rename = {},
		layout = {},
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

		if opts.scroll then
			require("utils").on_event({ "CmdlineEnter", "CmdlineLeave" }, function(ev)
				if ev.event == "CmdlineEnter" then
					Snacks.scroll.disable()
				else
					Snacks.scroll.enable()
				end
			end, {
				target = "/",
			})
		end
	end,
}
