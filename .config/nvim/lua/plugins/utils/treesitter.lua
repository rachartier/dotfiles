local utils = require("utils")

-- FIXME: Really a shitty update, seriously
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		event = { "LazyFile", "VeryLazy" },
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
		event = { "LazyFile", "VeryLazy" },
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
