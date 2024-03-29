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
		local ret = vim.fn["codeium#Accept"]()

		if vim.bo.filetype == "python" then
			local shift_len = vim.opt.shiftwidth:get()
			ret = string.gsub(ret, "\t", string.rep(" ", shift_len))
		end

		return ret
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-Down>", function()
		return vim.fn["codeium#CycleCompletions"](1)
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-Up>", function()
		return vim.fn["codeium#CycleCompletions"](-1)
	end, { expr = true, silent = true })

	vim.keymap.set("i", "<C-x>", function()
		return vim.fn["codeium#Clear"]()
	end, { expr = true, silent = true })
end

return M
