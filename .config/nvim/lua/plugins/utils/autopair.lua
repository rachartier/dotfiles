local M = {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
}

function M.config()
	require("nvim-autopairs").setup({})
end

return M
