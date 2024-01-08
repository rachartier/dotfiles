local M = {
	"ahmedkhalf/project.nvim",
	keys = {
		{ "<leader>fp", "<cmd>Telescope projects<cr>" },
	},
}

function M.config()
	require("project_nvim").setup({
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	})
end

return M
