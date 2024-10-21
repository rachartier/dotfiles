return {
	{
		"chrisgrieser/nvim-scissors",
		dependencies = { "hrsh7th/nvim-cmp" },
		event = { "VeryLazy" },
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
		lazy = true,
		build = "make install_jsregexp",
		event = "VeryLazy",
		keys = {
			{
				"<Tab>",
				function()
					local ls = require("luasnip")
					if ls.expand_or_jumpable() then
						ls.expand_or_jump()
					else
						vim.api.nvim_input("<C-V><Tab>")
					end
				end,
				mode = { "i", "s" },
				silent = true,
			},
			{
				"<S-Tab>",
				function()
					local ls = require("luasnip")
					ls.jump(-1)
				end,
				mode = { "i", "s" },
				silent = true,
			},
			{
				"<C-E>",
				function()
					local ls = require("luasnip")
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end,
				mode = { "i", "s" },
				silent = true,
			},
		},
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				-- "nvim-cmp",
				-- dependencies = {
				-- 	"saadparwaiz1/cmp_luasnip",
				-- },
				-- opts = function(_, opts)
				-- 	opts.snippet = {
				-- 		expand = function(args)
				-- 			require("luasnip").lsp_expand(args.body)
				-- 		end,
				-- 	}
				-- 	-- table.insert(opts.sources, { name = "luasnip" })
				-- end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
}
