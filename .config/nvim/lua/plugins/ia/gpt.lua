local M = {
	"robitx/gp.nvim",
	keys = {
		{ "<C-g>t", "<cmd>GpChatToggle popup<cr>" },
	},
	enabled = false,
}

function M.config()
	require("gp").setup()
end

return M
