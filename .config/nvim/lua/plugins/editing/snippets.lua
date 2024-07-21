return {
	{
		"chrisgrieser/nvim-scissors",
		event = "InsertEnter",
		opts = {
			backdrop = {
				enabled = false,
			},
			snippetDir = vim.fn.stdpath("config") .. "/snippets",
			editSnippetPopup = {
				height = 0.4, -- relative to the window, number between 0 and 1
				width = 0.6,
				border = "rounded",
				keymaps = {
					cancel = "q",
					saveChanges = "<CR>", -- alternatively, can also use `:w`
				},
			},
			telescope = {
				alsoSearchSnippetBody = true,
			},
			jsonFormatter = "jq", -- "yq"|"jq"|"none"
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "2.*",
		build = "make install_jsregexp",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"rafamadriz/friendly-snippets",
		},
		event = "LazyFile",
		config = function()
			local ls = require("luasnip")
			ls.setup({
				-- load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
				-- ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
				store_selection_keys = "<c-x>",
				enable_autosnippets = true,
			})
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_input("<C-V><Tab>")
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
			require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
		end,
	},
}
