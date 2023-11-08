local M = {
	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
}

function M.config()
	require("ultimate-autopair").setup({
		--Config goes here
	})
end

return M
