return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	opts = {
		icons = {
			inlay = {
				loading = "⏳",
				done = "✅",
				error = "❌",
			},
		},
		default_view = "headers_body",
	},

	config = function(_, opts)
		require("kulala").setup(opts)

		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<CR>",
			"<cmd>lua require('kulala').run()<cr>",
			{ noremap = true, silent = true, desc = "Execute the request" }
		)

		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"[",
			"<cmd>lua require('kulala').jump_prev()<cr>",
			{ noremap = true, silent = true, desc = "Jump to the previous request" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"]",
			"<cmd>lua require('kulala').jump_next()<cr>",
			{ noremap = true, silent = true, desc = "Jump to the next request" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<leader>i",
			"<cmd>lua require'kulala').inspect()<cr>",
			{ noremap = true, silent = true, desc = "Inspect the current request" }
		)
	end,
}
--
-- return {
-- 	"rest-nvim/rest.nvim",
-- 	lazy = false,
-- 	keys = {
-- 		{
-- 			"<CR>",
-- 			"<cmd>Rest run<cr>",
-- 			{ noremap = true, silent = true, desc = "Execute the request" },
-- 		},
-- 	},
-- 	config = function()
-- 		vim.g.rest_nvim = {}
-- 	end,
-- }
