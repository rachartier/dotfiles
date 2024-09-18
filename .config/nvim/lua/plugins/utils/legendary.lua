return {
	"mrjones2014/legendary.nvim",
	-- since legendary.nvim handles all your keymaps/commands,
	-- its recommended to load legendary.nvim before other plugins
	priority = 10000,
	event = "VeryLazy",

	keys = {
		{ "<C-p>", "<cmd>Legendary<CR>", { noremap = true, silent = true, desc = "Open Legendary" } },
	},

	opts = {
		extensions = { lazy_nvim = true },
	},
}
