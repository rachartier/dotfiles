local M = {
	"danymat/neogen",
	keys = {
		{ "<leader>gn", "<cmd>lua require('neogen').generate()<cr>", desc = "Generate annotation" },
	},
}

function M.config()
	require("neogen").setup({
		languages = {
			cs = {
				template = {
					annotation_convention = "xmldoc",
				},
			},
		},
	})
end

return M
