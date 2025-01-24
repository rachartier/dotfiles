return {
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
		"rachartier/tiny-buffers-switcher.nvim",
		enabled = false,
		event = "VeryLazy",
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
				use_fzf_lua = false,
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
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		event = "LazyFile",
		config = function()
			require("tiny-code-action").setup({
				-- backend = "difftastic",
				backend = "delta",
				-- backend = "vim",
				backend_opts = {
					delta = {
						args = {
							"--config=" .. os.getenv("HOME") .. "/.config/git/gitconfig",
						},
					},
				},
			})
		end,
	},
	{
		dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-glimmer.nvim",
		-- "rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>tg",
				function()
					require("tiny-glimmer").change_hl({
						"fade",
						"pulse",
					}, {
						from_color = "DiffAdd",
						to_color = "DiffDelete",
					})
				end,
				{ noremap = true, silent = true },
			},
		},
		opts = {
			refresh_interval_ms = 1,
			overwrite = {
				search = {
					enabled = true,
				},
				paste = {
					enabled = true,
				},
			},
			animations = {
				fade = {
					from_color = require("theme").get_colors().surface1,
				},
			},
		},
	},
	{
		dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-inline-diagnostic.nvim",
		-- "rachartier/tiny-inline-diagnostic.nvim",
		event = "LazyFile",
		-- commit = "0ac1133f0869730ced61b5f3c540748e29acca1a",
		config = function()
			require("tiny-inline-diagnostic").setup({
				-- preset = "powerline",
				-- hi = {
				-- background = "None",
				-- mixing_color = require("theme").get_colors().base,
				-- background = "None",
				-- },
				options = {
					-- add_messages = false,
					-- multiple_diag_under_cursor = true,
					multilines = {
						enabled = true,
						always_show = false,
					},
					virt_texts = {
						priority = 2048,
					},
				},
				disabled_ft = {},
				-- blend = {
				-- 	factor = 0.22,
				--
				-- },
			})

			-- require("utils").on_event("ColorScheme", function()
			-- 	local mixin_color = require("theme").get_colors().base
			-- 	require("tiny-inline-diagnostic").change({
			-- 		factor = 0.22,
			-- 	}, {
			-- 		mixing_color = mixin_color,
			-- 	})
			-- end, {
			-- 	target = "*",
			-- 	desc = "Change color scheme for tiny-inline-diagnostic",
			-- })

			--
			-- vim.keymap.set("n", "<leader>dd", "<cmd>set background=light<CR>",
			--     { noremap = true, silent = true })
			-- vim.keymap.set("n", "<leader>tid", function()
			-- 	vim.o.background = "dark"
			-- 	require("tiny-inline-diagnostic").change_severities()
			-- end, { noremap = true, silent = true })
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
		enabled = true,
		config = function()
			-- local colors = require("theme").get_colors()
			-- local colors = require("tokyonight.colors").setup()
			require("tiny-devicons-auto-colors").setup({
				-- colors = colors,
				autoreload = true,
				cache = { enabled = false },
			})

			require("tiny-devicons-auto-colors").apply()
		end,
	},
	-- {
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^5", -- Recommended
	-- 	lazy = false, -- This plugin is already lazy
	-- },
}
