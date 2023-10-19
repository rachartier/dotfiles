local M = {
	"potamides/pantran.nvim",
}

function M.config()
	require("pantran").setup({
		default_engine = "google",
		command = {
			default_mode = "replace",
		},
	})

	vim.keymap.set("x", "<leader>tr", require("pantran").motion_translate, {
		noremap = true,
		silent = true,
		expr = true,
	})

	local pantran = require("pantran")
	local opts = { noremap = true, silent = true, expr = true, desc = "Translate text" }
	vim.keymap.set("n", "<leader>tr", pantran.motion_translate, opts)
	vim.keymap.set("n", "<leader>trr", function()
		return pantran.motion_translate() .. "_"
	end, opts)
	vim.keymap.set("x", "<leader>tr", pantran.motion_translate, opts)
end

return M
