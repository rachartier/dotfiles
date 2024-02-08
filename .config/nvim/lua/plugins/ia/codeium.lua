local M = {
	"Exafunction/codeium.vim",
	dependencies = {

		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	event = "InsertEnter",
}

function M.config()
	vim.g.codeium_enabled = true

	vim.keymap.set("i", "<C-g>", function()
		return vim.fn["codeium#Accept"]()
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-g>n", function()
		return vim.fn["codeium#CycleCompletions"](1)
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-g>p", function()
		return vim.fn["codeium#CycleCompletions"](-1)
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-x>", function()
		return vim.fn["codeium#Clear"]()
	end, { expr = true, silent = true })
end

return M
