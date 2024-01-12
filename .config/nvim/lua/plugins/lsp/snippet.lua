return {
	{
		"mireq/luasnip-snippets",
		--dir = "/tmp/snippets",
		dependencies = { "L3MON4D3/LuaSnip" },
		init = function()
			vim.g.snips_author = "Raphaël CHARTIER"
			vim.g.snips_email = "raphael.chartier@michelin.com"
			vim.g.snips_company = "Michelin"
			require("luasnip_snippets.common.snip_utils").setup()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "2.*",
		build = "make install_jsregexp",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"rafamadriz/friendly-snippets",
		},
		init = function()
			local ls = require("luasnip")
			ls.setup({
				load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
				ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
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
		end,
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}