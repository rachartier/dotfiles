local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"lukas-reineke/cmp-under-comparator",
	},
}

function M.config()
	local cmp = require("cmp")
	local U = require("utils")
	local luasnip = require("luasnip")

	local has_words_before = function()
		if not table.unpack then
			table.unpack = unpack
		end
		local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local lspkind_comparator = function(conf)
		local lsp_types = require("cmp.types").lsp
		return function(entry1, entry2)
			if entry1.source.name ~= "nvim_lsp" then
				if entry2.source.name == "nvim_lsp" then
					return false
				else
					return nil
				end
			end
			local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
			local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

			local priority1 = conf.kind_priority[kind1] or 0
			local priority2 = conf.kind_priority[kind2] or 0
			if priority1 == priority2 then
				return nil
			end
			return priority2 < priority1
		end
	end

	local label_comparator = function(entry1, entry2)
		return entry1.completion_item.label < entry2.completion_item.label
	end

	local function format(_, item)
		local MAX_LABEL_WIDTH = 50
		local function whitespace(max, len)
			return (" "):rep(max - len)
		end

		local content = item.abbr
		if #content > MAX_LABEL_WIDTH then
			item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. "…"
		else
			item.abbr = content .. whitespace(MAX_LABEL_WIDTH, #content)
		end

		item.kind = " " .. (U.kind_icons[item.kind] or U.kind_icons.Unknown) .. "│"
		item.menu = nil

		return item
	end

	local filter_text = function(entry, _)
		local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
		return kind ~= "Text"
	end

	local mapping_selection_down = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		else
			fallback()
		end
	end, { "i", "s", "c" })

	local mapping_selection_up = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s", "c" })

	---@diagnostic disable-next-line: redundant-parameter
	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp", entry_filter = filter_text },
			{
				name = "buffer",
				option = {
					keyword_length = 4,
				},
				entry_filter = filter_text,
			},
			{ name = "dotenv" },
			{ name = "codeium" },
			{ name = "luasnip", entry_filter = filter_text },
			{ name = "latex_symbols" },
			{ name = "path" },
		},
		mapping = cmp.mapping.preset.insert({
			["<C-BS>"] = {
				i = cmp.config.disable,
			},
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = mapping_selection_down,
			["<S-Tab>"] = mapping_selection_up,

			["<Up>"] = mapping_selection_up,
			["<Down>"] = mapping_selection_down,
		}),

		formatting = {
			fields = { "kind", "abbr" },
			format = format,
		},
		sorting = {
			-- comparators = {
			-- 	require("cmp-under-comparator").under,
			-- 	            -- },
			comparators = {
				lspkind_comparator({
					kind_priority = {
						Field = 11,
						Property = 11,
						Constant = 10,
						Enum = 10,
						EnumMember = 10,
						Event = 10,
						Function = 10,
						Method = 10,
						Operator = 10,
						Reference = 10,
						Struct = 10,
						Variable = 12,
						File = 8,
						Folder = 8,
						Class = 5,
						Color = 5,
						Module = 5,
						Keyword = 2,
						Constructor = 1,
						Interface = 1,
						Snippet = 0,
						Text = 1,
						TypeParameter = 1,
						Unit = 1,
						Value = 1,
					},
				}),
				cmp.config.compare.exact,
				cmp.config.compare.sort_text,
				cmp.config.compare.offset,
				cmp.config.compare.score,
				require("clangd_extensions.cmp_scores"),

				label_comparator,

				cmp.config.compare.recently_used,
				require("cmp-under-comparator").under,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},

		window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
				scrollbar = true,
				border = U.default_border,
				col_offset = -1,
				side_padding = 0,
			}),
			documentation = cmp.config.window.bordered({
				winhighlight = "NormalFloat:NormalFloat,FloatBorder:PmenuBorder",
				scrollbar = true,
				border = U.default_border,
				side_padding = 1, -- Not working?
			}),
		},
		experimental = {
			-- ghost_text = {
			--     hl_group = "CmpGhostText",
			-- },
			ghost_text = false,
		},
	})

	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "cmp_git" },
		}, {
			{ name = "buffer" },
		}),
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline({
			["<Down>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
			["<Up>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
		}),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return M
