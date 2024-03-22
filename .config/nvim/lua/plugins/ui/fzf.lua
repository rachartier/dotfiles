local M = {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = false,
}

function M.config()
	local fzf = require("fzf-lua")

	fzf.setup({})

	vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
	vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "find buffers" })
	-- vim.keymap.set("n", "<tab>", builtin.buffers, { desc = "find buffers" })
	-- vim.keymap.set("n", "<s-tab>", builtin.buffers, { desc = "find buffers" })
	vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "find all lsp references" })
	vim.keymap.set("n", "<leader>fG", fzf.git_files, { desc = "find git files" })
	vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "grep words inside files" })
	-- vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "show documentations" })
	vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "grep string under cursor" })
	-- vim.keymap.set("n", "<leader>fm", "<cmd>telescope harpoon marks<cr>", { desc = "open harpoon marks" })
	-- vim.keymap.set("n", "<leader>c", function()
	--     require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
	--     end, { desc = "spelling suggestions" })
	-- vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "fuzzy find in file under cursor" })
end

return M
