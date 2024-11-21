return {
	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				enabled = false,
			},
			-- { "chrisgrieser/cmp-nerdfont", lazy = true },
			-- { "hrsh7th/cmp-emoji", lazy = true },
		},
		event = "InsertEnter",
		opts = {
			keymap = { preset = "super-tab" },
			accept = {
				auto_brackets = { enabled = true },
			},

			trigger = {
				completion = {
					keyword_range = "full",
				},
				signature_help = { enabled = false },
			},

			sources = {
				completion = {
					enabled_providers = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"lazydev",
						-- "nerdfont",
						-- "emoji",
					},
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					-- nerdfont = {
					-- 	name = "nerdfont",
					-- 	module = "blink.compat.source",
					-- 	transform_items = function(ctx, items)
					-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
					-- 		local kind = require("blink.cmp.types").CompletionItemKind.Text
					--
					-- 		for i = 1, #items do
					-- 			items[i].kind = kind
					-- 		end
					--
					-- 		return items
					-- 	end,
					-- },
					-- emoji = {
					-- 	name = "emoji",
					-- 	module = "blink.compat.source",
					-- 	transform_items = function(ctx, items)
					-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
					-- 		local kind = require("blink.cmp.types").CompletionItemKind.Text
					--
					-- 		for i = 1, #items do
					-- 			items[i].kind = kind
					-- 		end
					--
					-- 		return items
					-- 	end,
					-- },
				},
			},

			windows = {
				documentation = {
					-- border = "padded",
					-- border = require("config.ui.border").blink_empty,
					auto_show = true,
					auto_show_delay_ms = 0,
				},

				-- signature_help = {
				-- 	border = require("config.ui.border").default_border,
				-- },
				autocomplete = {
					scrollbar = true,
					-- border = "padded",
					-- border = require("config.ui.border").default_border,

					selection = "preselect",
				},
			},
			kind_icons = require("config.ui.kinds"),
		},
	},
}
