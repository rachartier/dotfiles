return {
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
		"rachartier/tiny-buffers-switcher.nvim",
		enabled = true,
		event = "LazyFile",
		keys = {
			{
				"<Tab>",
				function()
					require("tiny-buffers-switcher").switcher()
				end,
				{ noremap = true, silent = true },
			},
			{
				"<S-Tab>",
				function()
					require("tiny-buffers-switcher").switcher()
				end,
				{ noremap = true, silent = true },
			},
		},
		config = function()
			require("tiny-buffers-switcher").setup({
				--				use_fzf_lua = true,
			})
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_interpo_string.nvim",
		"rachartier/tiny-interpo-string.nvim",
		ft = { "python", "cs" },
		config = function()
			require("tiny_interpo_string").setup()
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-code-actions.nvim",
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup({
				backend = "delta",
				backend_opts = {
					delta = {
						args = {
							"--config=" .. os.getenv("HOME") .. "/.config/delta/delta.config",
						},
					},
				},
			})
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-inline-diagnostic.nvim",
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		config = function()
			local signs = {}

			if vim.g.neovide then
				signs = {
					left = "",
					right = "",
				}
			end

			require("tiny-inline-diagnostic").setup({
				signs = signs,
				hi = {
					-- background = "None",
					mixing_color = require("theme").get_colors().base,
				},
				blend = {
					factor = 0.22,
				},
			})

			--
			-- vim.keymap.set("n", "<leader>dd", "<cmd>set background=light<CR>",
			--     { noremap = true, silent = true })
			-- vim.keymap.set("n", "<leader>da", function()
			--         vim.o.background = "dark"
			--         require("tiny-inline-diagnostic").change({
			--                 factor = 0.22,
			--             },
			--             {
			--                 mixing_color = "#eaeaea"
			--             }
			--         )
			--     end,
			--     { noremap = true, silent = true })
			-- vim.keymap.set("n", "<leader>de", "<cmd>set background=dark<CR>",
			--     { noremap = true, silent = true })
		end,
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-devicons-auto-colors.nvim",
		"rachartier/tiny-devicons-auto-colors.nvim",
		branch = "main",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		enabled = false,
		config = function()
			local colors = require("theme").get_colors()
			-- local colors = require("tokyonight.colors").setup()
			require("tiny-devicons-auto-colors").setup({
				colors = colors,
				-- autoreload = true,
				cache = { enabled = true },
			})
		end,
	},
}
