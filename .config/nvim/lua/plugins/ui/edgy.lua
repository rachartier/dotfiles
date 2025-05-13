return {
	"folke/edgy.nvim",
	init = function()
		-- vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	opts = {
		icons = {
			closed = "  ",
			open = "  ",
		},
		animate = {
			enabled = false,
		},
		right = {
			{ ft = "copilot-chat", title = "Copilot Chat", size = { width = 0.30 } },
			{ ft = "kulala-json", title = "Kulala (JSON)", size = { width = 0.30 } },
			{ ft = "kulala-xml", title = "Kulala (XML)", size = { width = 0.30 } },
			{ ft = "kulala-html", title = "Kulala (HTML)", size = { width = 0.30 } },
			{ ft = "grug-far", title = "Grug Far", size = { width = 0.40 } },
		},
		left = {
			{ ft = "aerial", size = { width = 0.20 } },
			{ title = "Neotest Summary", ft = "neotest-summary", size = { width = 0.25 } },
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
			{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
		},
	},
	enabled = true,
	event = "VeryLazy",
}
