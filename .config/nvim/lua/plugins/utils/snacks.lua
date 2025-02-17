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
        { "<leader>fl", function() Snacks.picker.resume() end, desc = "Resume last picker" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fh", function() Snacks.picker.highlights() end, desc = "Show highlights" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        { "<leader>fd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "<leader>fr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "<leader>fI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "<leader>gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ff", function() Snacks.picker.files({
            exclude = { "node_modules", ".git", ".cache", ".local", ".npm", ".yarn", "__pycache__", ".venv" },
        }) end, desc = "Find Files" },
        { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Find Git Logs" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        -- { "<Tab>", function() Snacks.picker.buffers({
        --     sort_lastused = true,
        --     current = false,
        -- }) end, desc = "Find Git Files" },
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
		notifier = require("plugins.utils.snacks.notifier"),
		dashboard = require("plugins.utils.snacks.dashboard"),
		indent = require("plugins.utils.snacks.indent"),
		picker = require("plugins.utils.snacks.picker"),
		image = {},
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
