return {
	"mrjones2014/legendary.nvim",
	keys = {
		{
			"<C-p>",
			"<cmd>Legendary<CR>",
			silent = true,
		},
	},
	event = "BufRead",
	opts = {
		select_prompt = " legendary.nvim",
		icons = {
			-- keymap items list the modes in which the keymap applies
			-- by default, you can show an icon instead by setting this to
			-- a non-nil icon
			keymap = nil,
			command = "",
			fn = "󰡱",
			itemgroup = "",
		},
		extensions = {
			lazy_nvim = true,
		},
	},
}
