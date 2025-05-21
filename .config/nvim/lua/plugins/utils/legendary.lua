local signs = require("config.ui.signs")
local kinds = require("config.ui.kinds")

return {
	"mrjones2014/legendary.nvim",
	enabled = false,
	keys = {
		{
			"<C-p>",
			"<cmd>Legendary<CR>",
			silent = true,
		},
	},
	event = "VeryLazy",
	priority = 1,
	opts = {
		select_prompt = "Search for keymaps/commands",
		extensions = {
			lazy_nvim = true,
		},
		icons = {
			-- keymap items list the modes in which the keymap applies
			-- by default, you can show an icon instead by setting this to
			-- a non-nil icon
			keymap = nil,
			command = signs.others.terminal,
			fn = kinds.Function,
			itemgroup = kinds.Folder,
		},
	},
}
