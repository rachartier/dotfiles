local M = {
	"windwp/nvim-spectre",
}

function M.config()
	require("spectre").setup()

	vim.keymap.set("n", "<leader>R", '<cmd>lua require("spectre").open()<CR>', {
		desc = "Open Spectre",
	})
	vim.keymap.set("n", "<leader>rw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
		desc = "Search current word",
	})
	vim.keymap.set("v", "<leader>rw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
		desc = "Search current word",
	})
	vim.keymap.set("n", "<leader>rp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
		desc = "Search on current file",
	})
end

return M
