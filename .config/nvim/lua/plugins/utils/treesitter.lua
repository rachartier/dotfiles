return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = { "LazyFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			ignore_install = {},
			modules = {},
			ensure_installed = { "markdown", "markdown_inline", "regex", "vim", "requirements" },
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,
			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
				disable = function(lang, buf)
					local max_filesize = 1000 * 1024 -- 1 MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					node_decremental = "<BS>",
				},
			},
			indent = {
				enable = true,
				disable = {
					"markdown", -- indentation at bullet points is worse
				},
			},
			textobjects = {
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
		})

		vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
		vim.api.nvim_set_hl(0, "@markdown_check_done", { link = "@text.todo.checked" })
		vim.treesitter.language.register("lua", "pico8")
	end,
}
