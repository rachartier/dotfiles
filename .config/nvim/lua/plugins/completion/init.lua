return {

	"saghen/blink.cmp",
	-- version = "v0.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- { "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = false } },
		-- { "chrisgrieser/cmp-nerdfont", lazy = true },
		-- { "hrsh7th/cmp-emoji", lazy = true },
	},
	build = "cargo build --release",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = { preset = "super-tab" },

		completion = {
			documentation = {
				-- border = "padded",
				-- border = require("config.ui.border").blink_empty,
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			menu = {
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						return { pos[1], pos[2] }
					end
					return { vim.o.lines - 1, 0 }
				end,
			},
			trigger = {
				show_on_insert_on_trigger_character = false,
			},
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"lazydev",
				-- "nerdfont",
				-- "emoji",
			},
			providers = {
				-- dont show LuaLS require statements when lazydev has items
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
				-- 	-- nerdfont = {
				-- 	-- 	name = "nerdfont",
				-- 	-- 	module = "blink.compat.source",
				-- 	-- 	transform_items = function(ctx, items)
				-- 	-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
				-- 	-- 		local kind = require("blink.cmp.types").CompletionItemKind.Emoji
				-- 	--
				-- 	-- 		for i = 1, #items do
				-- 	-- 			items[i].kind = kind
				-- 	-- 		end
				-- 	--
				-- 	-- 		return items
				-- 	-- 	end,
				-- 	-- },
				-- 	-- emoji = {
				-- 	-- 	name = "emoji",
				-- 	-- 	module = "blink.compat.source",
				-- 	-- 	score_offset = -4,
				-- 	-- 	transform_items = function(ctx, items)
				-- 	-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
				-- 	-- 		local kind = require("blink.cmp.types").CompletionItemKind.Emoji
				-- 	--
				-- 	-- 		for i = 1, #items do
				-- 	-- 			items[i].kind = kind
				-- 	-- 		end
				-- 	--
				-- 	-- 		return items
				-- 	-- 	end,
				-- },
			},
		},

		-- windows = {

		-- signature_help = {
		-- 	border = require("config.ui.border").default_border,
		-- },
		-- autocomplete = {
		-- 	scrollbar = true,
		-- 	-- border = "padded",
		-- 	-- border = require("config.ui.border").default_border,
		--
		-- 	selection = "preselect",
		-- },
		-- },
		appearance = {
			kind_icons = require("config.ui.kinds"),
		},
	},
}
