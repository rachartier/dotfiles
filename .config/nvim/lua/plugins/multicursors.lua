local M = {
	"smoka7/multicursors.nvim",
	event = "VeryLazy",
	dependencies = {
		"smoka7/hydra.nvim",
	},
	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	keys = {
		{
			mode = { "v", "n" },
			"<Leader>m",
			"<cmd>MCstart<cr>",
			desc = "Create a selection for selected text or word under the cursor",
		},
	},
}

function M.config()
	require("multicursors").setup({
		hint_config = {
			border = "rounded",
			position = "bottom",
		},
	})
end

return M
