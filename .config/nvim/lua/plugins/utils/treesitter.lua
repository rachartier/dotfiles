local utils = require("utils")

-- FIXME: Really a shitty update, seriously
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "LazyFile", "VeryLazy" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				event = "VeryLazy",
				branch = "main",
				opts = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						include_surrounding_whitespace = true,
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["<C-down>"] = "@function.outer",
							["<C-j>"] = "@function.outer",
						},
						-- goto_next_end = {
						-- 	["<C-J"] = "@function.outer",
						-- },
						goto_previous_start = {
							["<C-up>"] = "@function.outer",
							["<C-k>"] = "@function.outer",
						},
						goto_previous_end = {
							["<C-K>"] = "@function.outer",
						},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						-- goto_next = {
						-- 	["]d"] = "@conditional.outer",
						-- },
						-- goto_previous = {
						-- 	["[d"] = "@conditional.outer",
						-- },
					},
				},
			},
		},
		-- event = { "LazyFile", "VeryLazy" },
		-- lazy = false,
		-- opts = {
		-- ignore_install = {},
		-- modules = {},
		-- ensure_installed = {},
		-- -- Install parsers synchronously (only applied to `ensure_installed`)
		-- sync_install = false,
		-- -- Automatically install missing parsers when entering buffer
		-- -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		-- auto_install = true,
		--
		-- -- required for windwp/nvim-ts-autotag to works.
		-- autotag = {
		-- 	enable = false,
		-- },
		--
		-- highlight = {
		-- 	-- `false` will disable the whole extension
		-- 	enable = true,
		-- 	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- 	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- 	-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- 	-- Instead of true it can also be a list of languages
		-- 	additional_vim_regex_highlighting = false,
		-- 	disable = function(lang, buf)
		-- 		local max_filesize = 1000 * 1024 -- 1 MB
		-- 		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		-- 		if ok and stats and stats.size > max_filesize then
		-- 			return true
		-- 		end
		-- 	end,
		-- },
		-- incremental_selection = {
		-- 	enable = true,
		-- 	keymaps = {
		-- 		-- init_selection = "<CR>",
		-- 		-- node_incremental = "<CR>",
		-- 		node_decremental = "<BS>",
		-- 	},
		-- },
		-- indent = {
		-- 	enable = false,
		-- 	disable = {
		-- 		"markdown", -- indentation at bullet points is worse
		-- 	},
		-- },
		-- },
		init = function()
			vim.g.loaded_nvim_treesitter = 1
		end,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Enable Treesitter",
				group = vim.api.nvim_create_augroup("enable_treesitter", {}),
				-- Don't filter by `pattern`, install and enable Treesitter parsers for all languages.
				callback = function()
					-- Enable Treesitter syntax highlighting.
					if pcall(vim.treesitter.start) then
						-- Use Treesitter indentation and folds.
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
			})
		end,
	},
	{
		"lewis6991/ts-install.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("ts-install").setup({
				ensure_install = {
					"markdown_inline",
					"markdown",
					"regex",
					"vim",
					"requirements",
					"gitcommit",
					"git_rebase",
					"diff",
					"json",
					"lua",
					"c",
					"bash",
				},
				auto_install = true,
			})
		end,
	},
}
