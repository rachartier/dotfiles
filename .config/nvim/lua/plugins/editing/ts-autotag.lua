return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = true, -- Auto close on trailing </
	},

	config = function(_, _opts)
		require("nvim-ts-autotag").setup({ opts = _opts })
	end,
}
