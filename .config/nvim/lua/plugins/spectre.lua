local M = {
	"windwp/nvim-spectre",
	keys = {
		{
			"<leader>R",
			'<cmd>lua require("spectre").open()<CR>',
			desc = "Open Spectre",
		},
		{
			"<leader>rw",
			'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
			desc = "Search current word",
		},
		{
			"<leader>rw",
			'<esc><cmd>lua require("spectre").open_visual()<CR>',
			desc = "Search current word",
		},
		{
			"<leader>rp",
			'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
			desc = "Search on current file",
		},
	},
}

function M.config()
	require("spectre").setup()
end

return M
