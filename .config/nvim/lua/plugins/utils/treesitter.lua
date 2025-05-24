local utils = require("utils")
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	-- dependencies = {
	-- "nvim-treesitter/nvim-treesitter-textobjects",
	-- },
	event = { "LazyFile", "VeryLazy" },
	-- lazy = false,
	-- opts = {
	-- 	ignore_install = {},
	-- 	modules = {},
	-- 	ensure_installed = {},
	-- 	-- Install parsers synchronously (only applied to `ensure_installed`)
	-- 	sync_install = false,
	-- 	-- Automatically install missing parsers when entering buffer
	-- 	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	-- 	auto_install = true,
	--
	-- 	-- required for windwp/nvim-ts-autotag to works.
	-- 	autotag = {
	-- 		enable = false,
	-- 	},
	--
	-- 	highlight = {
	-- 		-- `false` will disable the whole extension
	-- 		enable = true,
	-- 		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	-- 		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	-- 		-- Using this option may slow down your editor, and you may see some duplicate highlights.
	-- 		-- Instead of true it can also be a list of languages
	-- 		additional_vim_regex_highlighting = false,
	-- 		disable = function(lang, buf)
	-- 			local max_filesize = 1000 * 1024 -- 1 MB
	-- 			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	-- 			if ok and stats and stats.size > max_filesize then
	-- 				return true
	-- 			end
	-- 		end,
	-- 	},
	-- 	incremental_selection = {
	-- 		enable = true,
	-- 		keymaps = {
	-- 			-- init_selection = "<CR>",
	-- 			-- node_incremental = "<CR>",
	-- 			node_decremental = "<BS>",
	-- 		},
	-- 	},
	-- 	indent = {
	-- 		enable = false,
	-- 		disable = {
	-- 			"markdown", -- indentation at bullet points is worse
	-- 		},
	-- 	},
	-- 	-- textobjects = {
	-- 	-- 	select = {
	-- 	-- 		enable = true,
	-- 	-- 		lookahead = true,
	-- 	-- 		keymaps = {
	-- 	-- 			["af"] = "@function.outer",
	-- 	-- 			["if"] = "@function.inner",
	-- 	-- 			["ac"] = "@class.outer",
	-- 	-- 			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
	-- 	-- 			["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
	-- 	-- 		},
	-- 	-- 		selection_modes = {
	-- 	-- 			["@parameter.outer"] = "v", -- charwise
	-- 	-- 			["@function.outer"] = "V", -- linewise
	-- 	-- 			["@class.outer"] = "<c-v>", -- blockwise
	-- 	-- 		},
	-- 	-- 		include_surrounding_whitespace = true,
	-- 	-- 	},
	-- 	-- 	move = {
	-- 	-- 		enable = true,
	-- 	-- 		set_jumps = true, -- whether to set jumps in the jumplist
	-- 	-- 		goto_next_start = {
	-- 	-- 			["<C-down>"] = "@function.outer",
	-- 	-- 			["<C-j>"] = "@function.outer",
	-- 	-- 		},
	-- 	-- 		-- goto_next_end = {
	-- 	-- 		-- 	["<C-J"] = "@function.outer",
	-- 	-- 		-- },
	-- 	-- 		goto_previous_start = {
	-- 	-- 			["<C-up>"] = "@function.outer",
	-- 	-- 			["<C-k>"] = "@function.outer",
	-- 	-- 		},
	-- 	-- 		goto_previous_end = {
	-- 	-- 			["<C-K>"] = "@function.outer",
	-- 	-- 		},
	-- 	-- 		-- Below will go to either the start or the end, whichever is closer.
	-- 	-- 		-- Use if you want more granular movements
	-- 	-- 		-- Make it even more gradual by adding multiple queries and regex.
	-- 	-- 		-- goto_next = {
	-- 	-- 		-- 	["]d"] = "@conditional.outer",
	-- 	-- 		-- },
	-- 	-- 		-- goto_previous = {
	-- 	-- 		-- 	["[d"] = "@conditional.outer",
	-- 	-- 		-- },
	-- 	-- 	},
	-- 	-- },
	-- },
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		local defaults = {
			"markdown_inline",
			"regex",
			"vim",
			"requirements",
			"gitcommit",
			"git_rebase",
		}

		for _, parser in ipairs(defaults) do
			require("nvim-treesitter").install(parser)
		end

		utils.on_event("BufEnter", function(e)
			local parser = vim.treesitter.language.get_lang(vim.bo.ft)

			if parser then
				require("nvim-treesitter").install(parser)
			end
		end, {
			desc = "Install treesitter parser for current buffer",
		})

		vim.treesitter.language.register("bash", "zsh")

		-- vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
		-- vim.api.nvim_set_hl(0, "@markdown_check_done", { link = "@text.todo.checked" })
	end,
}
