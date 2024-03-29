local M = {

	"MeanderingProgrammer/py-requirements.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cond = function()
		return vim.fn.expand("%:t") == "requirements.txt"
	end,
}

function M.config()
	require("py-requirements").setup({
		-- Enabled by default if you do not use `nvim-cmp` set to false
		enable_cmp = true,
	})
end

return M
