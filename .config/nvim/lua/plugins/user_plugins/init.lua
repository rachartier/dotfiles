-- local user_plugins = require("user_plugins.user_plugins")

local dev = false

if dev then
	return {
		{
			dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
			keys = {
				{
					"<Tab>",
					function()
						require("tiny_buffers_switcher").switcher()
					end,
					{ noremap = true, silent = true },
				},
				{
					"<S-Tab>",
					function()
						require("tiny_buffers_switcher").switcher()
					end,
					{ noremap = true, silent = true },
				},
			},
			config = function()
				require("tiny_buffers_switcher").setup()
			end,
		},
		{
			dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_interpo_string.nvim",
		},
		{
			dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-devicons-auto-colors.nvim",
			event = "VeryLazy",
			config = function()
				local colors = require("theme").get_colors()
				require("tiny-devicons-auto-colors").setup({
					colors = {
						colors.red,
						colors.green,
						colors.yellow,
						colors.blue,
						colors.purple,
						colors.peach,
						colors.maroon,
						colors.text,
						colors.mauve,
						colors.lavender,
						colors.sappphire,
						colors.flamingo,
					},
				})
			end,
		},
	}
end

return {
	{
		"rachartier/tiny-buffers-switcher.nvim",
		event = "LazyFile",
		keys = {
			{
				"<Tab>",
				function()
					require("tiny_buffers_switcher").switcher()
				end,
				{ noremap = true, silent = true },
			},
			{
				"<S-Tab>",
				function()
					require("tiny_buffers_switcher").switcher()
				end,
				{ noremap = true, silent = true },
			},
		},
		config = function()
			require("tiny_buffers_switcher").setup()
		end,
	},
	{
		"rachartier/tiny-interpo-string.nvim",
		ft = { "python", "cs" },
		config = function()
			require("tiny_interpo_string").setup()
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-devicons-auto-colors.nvim",
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		enabled = true,
		config = function()
			local colors = require("theme").get_colors()
			-- local colors = require("tokyonight.colors").setup()
			require("tiny-devicons-auto-colors").setup({
				colors = colors,
				autoreload = false,
			})
		end,
	},
}
