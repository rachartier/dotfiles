local utils = require("utils")
return {
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
		"rachartier/tiny-buffers-switcher.nvim",
		enabled = true,
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
		opts = {
			use_snacks = true,
		},
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
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-code-action.nvim",
		"rachartier/tiny-code-action.nvim",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "LazyFile",
		config = function()
			require("tiny-code-action").setup({
				-- backend = "difftastic",
				backend = "vim",
				picker = "snacks",
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
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-glimmer.nvim",
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		-- "rachartier/tiny-glimmer.nvim",
		-- dependencies = {
		-- 	{
		-- 		"gbprod/yanky.nvim",
		-- 		opts = {
		-- 			highlight = {
		-- 				on_put = false,
		-- 				on_yank = false,
		-- 				timer = 150,
		-- 			},
		-- 		},
		-- 	},
		-- },
		--
		-- event = "VeryLazy",
		-- enabled = true,
		opts = {
			transparency_color = require("theme").get_colors().base,
			overwrite = {
				yank = {
					enabled = true,
					default_animation = {
						name = "fade",
						settings = {
							from_color = require("theme").get_colors().overlay1,
						},
					},
				},
				search = {
					enabled = true,
				},
				paste = {
					enabled = true,
				},
				undo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = utils.darken(require("theme").get_colors().red, 0.6),
						},
					},
				},
				redo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = utils.darken(require("theme").get_colors().green, 0.6),
						},
					},
				},
			},
		},
	},
	{
		-- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-inline-diagnostic.nvim",
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LazyFile",
		enabled = true,
		-- commit = "0ac1133f0869730ced61b5f3c540748e29acca1a",
		config = function()
			-- vim.api.nvim_set_hl(0, "CursorLine", { bg = require("theme").get_colors().surface1, bold = false })
			require("tiny-inline-diagnostic").setup({
				transparent_bg = false,
				hi = {
					mixing_color = require("theme").get_colors().base,
				},
				options = {
					-- add_messages = false,
					multilines = {
						enabled = true,
						always_show = false,
					},
					virt_texts = {
						priority = 2048,
					},
				},
				disabled_ft = {},
			})

			-- require("tiny-inline-diagnostic").setup({
			-- 	signs = {
			-- 		left = "",
			-- 		right = "",
			-- 		diag = "■",
			-- 		arrow = "",
			-- 		up_arrow = "",
			-- 		vertical = "  │",
			-- 		vertical_end = "  └",
			-- 	},
			-- 	blend = { factor = 0 },
			-- 	hi = {
			-- 		background = "None",
			-- 	},
			-- 	options = {
			-- 		multilines = {
			-- 			enabled = true,
			-- 			always_show = true,
			-- 		},
			-- 	},
			-- })
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
		enabled = false,
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
