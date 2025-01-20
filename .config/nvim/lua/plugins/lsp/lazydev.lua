return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = vim.fn.expand("${3rd}/love2d/library"), words = { "love" } },
				{
					path = "/home/rachartier/.local/share/nvim/mason/packages/lua-language-server/libexec/meta/3rd/love2d",
					words = { "love" },
				},
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
