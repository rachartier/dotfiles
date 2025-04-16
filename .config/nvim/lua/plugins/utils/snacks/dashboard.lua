return {
	enabled = true,
	preset = {
		---@type snacks.dashboard.Item[]|fun(items:snacks.dashboard.Item[]):snacks.dashboard.Item[]?

		keys = function()
			local compact = vim.o.columns < 60
			---@type snacks.dashboard.Item[]
			local items = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
				{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			}

			local width = vim.o.columns
			local max_line_width = 0

			if compact then
				for _, item in ipairs(items) do
					item.desc = "[" .. item.key .. "] " .. item.desc
					max_line_width = math.max(max_line_width, #item.desc + vim.fn.strdisplaywidth(item.icon))
				end

				for _, item in ipairs(items) do
					item.icon = string.rep(" ", (width - max_line_width) / 2 + max_line_width / 4) .. item.icon
				end
			end

			return items
		end,

		header = [[

███┐   ██┐███████┐ ██████┐ ██┐   ██┐██┐███┐   ███┐
████┐  ██│██┌────┘██┌───██┐██│   ██│██│████┐ ████│
██┌██┐ ██│█████┐  ██│   ██│██│   ██│██│██┌████┌██│
██│└██┐██│██┌──┘  ██│   ██│└██┐ ██┌┘██│██│└██┌┘██│
██│ └████│███████┐└██████┌┘ └████┌┘ ██│██│ └─┘ ██│
└─┘  └───┘└──────┘ └─────┘   └───┘  └─┘└─┘     └─┘
]],
	},
	formats = {
		terminal = { align = "center" },
		version = { "%s", align = "center" },
	},

	sections = {
		{
			section = "header",
			-- height = 14,
			-- width = 10,
			-- enabled = function()
			-- 	return vim.o.lines > 30
			-- end,
		},
		function()
			local gap = 1
			if vim.o.lines <= 30 then
				gap = 0
			end
			return {
				section = "keys",
				gap = gap,
				padding = 1,
			}
		end,
		{ section = "startup" },

		function()
			local in_git = Snacks.git.get_root() ~= nil
			local cmds = {
				{
					title = "Git Graph",
					icon = " ",
					cmd = [[echo -e "$(git-graph --style round --color always --wrap 50 0 8 -f 'oneline')"]],
					indent = 1,
					height = 24,
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
