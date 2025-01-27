return {

	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		-- { "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = false } },
		-- { "chrisgrieser/cmp-nerdfont", lazy = true },
		-- { "hrsh7th/cmp-emoji", lazy = true },
	},
	-- build = "cargo build --release",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = { preset = "super-tab" },

		enabled = function()
			return not vim.tbl_contains({
				"Avante",
				"copilot-chat",
			}, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
		end,

		completion = {
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
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
						if vim.fn.mode() == "c" and vim.fn.getcmdtype() == "/" then
							return { pos[1] - 1, pos[2] }
						end
						return { pos[1], pos[2] }
					end

					return { vim.o.lines + 1, 0 }
				end,
				draw = {
					treesitter = { "lsp" },
					-- components = {
					-- 	kind_icon = {
					-- 		ellipsis = false,
					-- 		text = function(ctx)
					-- 			local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
					-- 			return kind_icon
					-- 		end,
					-- 		-- Optionally, you may also use the highlights from mini.icons
					-- 		highlight = function(ctx)
					-- 			local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
					-- 			return hl
					-- 		end,
					-- 	},
					-- },
				},
			},
			trigger = {
				show_on_insert_on_trigger_character = false,
			},
		},

		sources = {
			default = {
				"copilot",
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
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						max_completions = 3,
						max_attempts = 4,
					},
				},
				-- nerdfont = {
				-- 	name = "nerdfont",
				-- 	module = "blink.compat.source",
				-- 	transform_items = function(ctx, items)
				-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
				-- 		local kind = require("blink.cmp.types").CompletionItemKind.Emoji
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
				-- 	score_offset = -4,
				-- 	transform_items = function(ctx, items)
				-- 		-- TODO: check https://github.com/Saghen/blink.cmp/pull/253#issuecomment-2454984622
				-- 		local kind = require("blink.cmp.types").CompletionItemKind.Emoji
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
