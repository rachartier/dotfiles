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
	}
end

return {
	{
		"rachartier/tiny_buffers_switcher",
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
		"rachartier/tiny_interpo_string",
		ft = { "python", "cs" },
		config = function()
			require("tiny_interpo_string").setup()
		end,
	},
}
