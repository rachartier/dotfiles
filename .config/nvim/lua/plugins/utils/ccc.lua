local M = {
	"uga-rosa/ccc.nvim",
	event = { "BufEnter", "BufNewFile" },
}

function M.config()
	require("ccc").setup({
		highlighter = {
			auto_enable = true,
			lsp = true,
			excludes = { "lazy" },
		},
	})
end

return M
