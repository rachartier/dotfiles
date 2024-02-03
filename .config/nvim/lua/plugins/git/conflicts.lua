local M = {
	"akinsho/git-conflict.nvim",
}

function M.config()
	require("git-conflict").setup()
end

return M
