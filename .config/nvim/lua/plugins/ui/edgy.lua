return {
	"folke/edgy.nvim",
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	opts = {
		animate = {
			enabled = false,
		},
		right = {
			{ ft = "copilot-chat", title = "Copilot Chat", size = { width = 0.30 } },
		},
		left = {
			{ ft = "spectre_panel", size = { width = 0.40 } },
		},
		bottom = {
			"trouble",
			{ ft = "qf", title = "QuickFix" },
			{
				ft = "help",
				size = { height = 40 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
	},
	enabled = true,
	event = "LazyFile",
}
