local M = {
	"Wansmer/symbol-usage.nvim",
}

function M.config()
	require("symbol-usage").setup({
		vt_position = "end_of_line",
	})
end

return M
