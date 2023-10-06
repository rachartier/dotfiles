local M = {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {

		{ "<leader>tt", "<cmd>TroubleToggle<cr>" },
		{
			"<leader>tn",
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
		},
		{
			"<leader>tp",
			function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end,
		},
	},
}
function M.config()
	require("trouble").setup({
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		use_diagnostic_signs = true,
		auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
		position = "bottom",
	})
end

return M
