return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saghen/blink.compat",
			-- { "chrisgrieser/cmp-nerdfont", lazy = true },
			-- { "hrsh7th/cmp-emoji", lazy = true },
		},
		event = "VeryLazy",
		version = "v0.*",

		opts = {
			keymap = { preset = "super-tab" },
			accept = {
				auto_brackets = { enabled = true },
			},

			trigger = {
				signature_help = { enabled = false },
			},

			sources = {
				-- add lazydev to your completion providers
				completion = {
					enabled_providers = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"lazydev",
					},
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					-- nerdfont = {
					-- 	name = "nerdfont",
					-- 	module = "blink.compat.source",
					-- },
					-- emoji = {
					-- 	name = "emoji",
					-- 	module = "blink.compat.source",
					-- },
				},
			},

			windows = {
				documentation = {
					min_width = 15,
					max_width = 50,
					max_height = 15,
					border = require("config.icons").default_border,
					auto_show = true,
					auto_show_delay_ms = 0,
				},
				-- signature_help = {
				-- 	border = require("config.icons").default_border,
				-- },
				autocomplete = {
					min_width = 10,
					border = require("config.icons").default_border,

					-- autocomplete = {
					-- 	border = require("config.icons").default_border,
					-- },

					selection = "preselect",
					draw = function(ctx)
						-- local icon_hl = vim.api.nvim_get_hl_by_name("BlinkCmpKind", true) and "BlinkCmpKind" .. ctx.kind
						-- 	or "BlinkCmpKind"
						local icon_hl = "BlinkCmpKind" .. ctx.kind
						return {
							{
								" " .. ctx.kind_icon .. "│" .. " ",
								hl_group = icon_hl,
							},
							{
								ctx.item.label .. " ",
								fill = true,
								hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
								max_width = 45,
							},
						}
					end,
				},
			},
			kind_icons = require("config.icons").kind_icons,
		},
	},
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	-- "iguanacucumber/magazine.nvim",
	-- 	-- name = "nvim-cmp",
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 		"hrsh7th/cmp-cmdline",
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-nvim-lua",
	-- 		"hrsh7th/cmp-emoji",
	-- 		"hrsh7th/cmp-calc",
	-- 		"chrisgrieser/cmp-nerdfont",
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 		"lukas-reineke/cmp-under-comparator",
	-- 	},
	-- 	event = { "VeryLazy" },
	-- 	opts = function(_, opts)
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, {
	-- 			name = "lazydev",
	-- 			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
	-- 		})
	-- 	end,
	-- 	config = function()
	-- 		local cmp = require("cmp")
	-- 		local icons = require("config.icons")
	--
	-- 		local luasnip = require("luasnip")
	--
	-- 		local has_words_before = function()
	-- 			if not table.unpack then
	-- 				table.unpack = unpack
	-- 			end
	-- 			local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	-- 			return col ~= 0
	-- 				and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	-- 		end
	--
	-- 		local lspkind_comparator = function(conf)
	-- 			local lsp_types = require("cmp.types").lsp
	-- 			return function(entry1, entry2)
	-- 				if entry1.source.name ~= "nvim_lsp" then
	-- 					if entry2.source.name == "nvim_lsp" then
	-- 						return false
	-- 					else
	-- 						return nil
	-- 					end
	-- 				end
	-- 				local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
	-- 				local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
	--
	-- 				local priority1 = conf.kind_priority[kind1] or 0
	-- 				local priority2 = conf.kind_priority[kind2] or 0
	-- 				if priority1 == priority2 then
	-- 					return nil
	-- 				end
	-- 				return priority2 < priority1
	-- 			end
	-- 		end
	--
	-- 		local label_comparator = function(entry1, entry2)
	-- 			return entry1.completion_item.label < entry2.completion_item.label
	-- 		end
	--
	-- 		local function format(entry, item)
	-- 			local MAX_LABEL_WIDTH = 50
	-- 			local function whitespace(max, len)
	-- 				return (" "):rep(max - len)
	-- 			end
	--
	-- 			local content = item.abbr
	-- 			if #content > MAX_LABEL_WIDTH then
	-- 				item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. "…"
	-- 			else
	-- 				item.abbr = content .. whitespace(MAX_LABEL_WIDTH, #content)
	-- 			end
	--
	-- 			local kind = (icons.kind_icons[item.kind] or icons.kind_icons.Unknown)
	--
	-- 			if entry.source.name == "calc" then
	-- 				kind = icons.kind_icons.Calculator
	-- 			elseif entry.source.name == "emojis" or entry.source.name == "nerdfont" then
	-- 				kind = icons.kind_icons.Emoji
	-- 			end
	--
	-- 			item.kind = " " .. kind .. "│"
	-- 			item.menu = nil
	--
	-- 			return item
	-- 		end
	--
	-- 		local filter_text = function(entry, _)
	-- 			local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
	-- 			return kind ~= "Text"
	-- 		end
	--
	-- 		local mapping_selection_down = cmp.mapping(function(fallback)
	-- 			if cmp.visible() then
	-- 				cmp.select_next_item()
	-- 			elseif luasnip.expand_or_jumpable() then
	-- 				luasnip.expand_or_jump()
	-- 			else
	-- 				fallback()
	-- 			end
	-- 		end, { "i", "s", "c" })
	--
	-- 		local mapping_selection_up = cmp.mapping(function(fallback)
	-- 			if cmp.visible() then
	-- 				cmp.select_prev_item()
	-- 			elseif luasnip.jumpable(-1) then
	-- 				luasnip.jump(-1)
	-- 			else
	-- 				fallback()
	-- 			end
	-- 		end, { "i", "s", "c" })
	--
	-- 		---@diagnostic disable-next-line: redundant-parameter
	-- 		cmp.setup({
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			sources = {
	-- 				{ name = "nerdfont" },
	-- 				{ name = "emoji" },
	-- 				{ name = "nvim_lsp", entry_filter = filter_text, keyword_length = 2 },
	-- 				{
	-- 					name = "buffer",
	-- 					option = {
	-- 						keyword_length = 4,
	-- 					},
	-- 					entry_filter = filter_text,
	-- 				},
	-- 				{ name = "dotenv" },
	-- 				{ name = "luasnip", entry_filter = filter_text, keyword_length = 2 },
	-- 				{ name = "path" },
	-- 				{ name = "calc", kind = "  " },
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-BS>"] = {
	-- 					i = cmp.config.disable,
	-- 				},
	-- 				["<C-u>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-d>"] = cmp.mapping.scroll_docs(4),
	-- 				["<C-Space>"] = cmp.mapping.complete(),
	-- 				["<C-e>"] = cmp.mapping.abort(),
	-- 				["<CR>"] = cmp.mapping.confirm({ select = true }),
	-- 				["<Tab>"] = mapping_selection_down,
	-- 				["<S-Tab>"] = mapping_selection_up,
	--
	-- 				["<Up>"] = mapping_selection_up,
	-- 				["<Down>"] = mapping_selection_down,
	-- 			}),
	--
	-- 			formatting = {
	-- 				fields = { "kind", "abbr" },
	-- 				format = format,
	-- 			},
	-- 			sorting = {
	-- 				-- comparators = {
	-- 				-- 	require("cmp-under-comparator").under,
	-- 				-- 	            -- },
	-- 				-- comparators = {
	-- 				--
	-- 				-- 	cmp.config.compare.offset,
	-- 				-- 	cmp.config.compare.exact,
	-- 				-- 	cmp.config.compare.score,
	-- 				-- 	lspkind_comparator({
	-- 				-- 		kind_priority = {
	-- 				-- 			Field = 11,
	-- 				-- 			Property = 11,
	-- 				-- 			Constant = 10,
	-- 				-- 			Enum = 10,
	-- 				-- 			EnumMember = 10,
	-- 				-- 			Event = 10,
	-- 				-- 			Function = 10,
	-- 				-- 			Method = 10,
	-- 				-- 			Operator = 10,
	-- 				-- 			Reference = 10,
	-- 				-- 			Struct = 10,
	-- 				-- 			Variable = 12,
	-- 				-- 			File = 8,
	-- 				-- 			Folder = 8,
	-- 				-- 			Class = 5,
	-- 				-- 			Color = 5,
	-- 				-- 			Module = 5,
	-- 				-- 			Keyword = 2,
	-- 				-- 			Constructor = 1,
	-- 				-- 			Interface = 1,
	-- 				-- 			Snippet = 0,
	-- 				-- 			Text = 1,
	-- 				-- 			TypeParameter = 1,
	-- 				-- 			Unit = 1,
	-- 				-- 			Value = 1,
	-- 				-- 		},
	-- 				-- 	}),
	-- 				-- 	require("clangd_extensions.cmp_scores"),
	-- 				-- 	label_comparator,
	-- 				-- 	cmp.config.compare.sort_text,
	-- 				--
	-- 				-- 	cmp.config.compare.recently_used,
	-- 				-- 	require("cmp-under-comparator").under,
	-- 				-- 	cmp.config.compare.length,
	-- 				-- 	cmp.config.compare.order,
	-- 				-- },
	-- 				comparators = {
	-- 					cmp.config.compare.offset,
	-- 					cmp.config.compare.exact,
	-- 					cmp.config.compare.score,
	-- 					cmp.config.compare.recently_used,
	-- 					require("cmp-under-comparator").under,
	-- 					cmp.config.compare.kind,
	-- 				},
	-- 			},
	--
	-- 			window = {
	-- 				completion = cmp.config.window.bordered({
	-- 					winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
	-- 					scrollbar = true,
	-- 					border = icons.default_border,
	-- 					col_offset = -1,
	-- 					side_padding = 0,
	-- 				}),
	-- 				documentation = cmp.config.window.bordered({
	-- 					winhighlight = "NormalFloat:NormalFloat,FloatBorder:PmenuBorder",
	-- 					scrollbar = true,
	-- 					border = icons.default_border,
	-- 					side_padding = 1, -- Not working?
	-- 				}),
	-- 			},
	-- 			view = {
	-- 				entries = {
	-- 					follow_cursor = false,
	-- 				},
	-- 			},
	-- 			-- experimental = {
	-- 			--     ghost_text = {
	-- 			--         hl_group = "CmpGhostText",
	-- 			--     },
	-- 			--     ghost_text = false,
	-- 			-- },
	-- 		})
	--
	-- 		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	-- 		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	--
	-- 		cmp.setup.filetype("gitcommit", {
	-- 			sources = cmp.config.sources({
	-- 				{ name = "cmp_git" },
	-- 			}, {
	-- 				{ name = "buffer" },
	-- 			}),
	-- 		})
	--
	-- 		cmp.setup.cmdline({ "/", "?" }, {
	-- 			mapping = cmp.mapping.preset.cmdline(),
	-- 			sources = {
	-- 				{ name = "buffer" },
	-- 			},
	-- 		})
	--
	-- 		cmp.setup.cmdline(":", {
	-- 			mapping = cmp.mapping.preset.cmdline({
	-- 				["<Down>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
	-- 				["<Up>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
	-- 			}),
	-- 			sources = cmp.config.sources({
	-- 				{ name = "path" },
	-- 			}, {
	-- 				{ name = "cmdline" },
	-- 			}),
	-- 		})
	--
	-- 		cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	-- 			sources = {
	-- 				{ name = "dap" },
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
