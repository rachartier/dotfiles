local M = {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = true,
}

function M.config()
	require("oil").setup({
		keymaps = {
			["<BS>"] = "actions.parent",
		},
		float = {
			padding = 2,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			override = function(conf)
				local win_height = math.ceil(vim.o.lines * 0.3)
				local win_width = math.ceil(vim.o.columns * 0.4)

				local row = math.ceil((vim.o.lines - win_height) * 0.4)
				local col = math.ceil((vim.o.columns - win_width) * 0.5)

				conf.width = win_width
				conf.height = win_height
				conf.row = row
				conf.col = col

				return conf
			end,
		},
	})
	vim.keymap.set("n", "<leader>to", function()
		require("oil").open_float()
	end, { desc = "Open parent directory" })
end

return M
