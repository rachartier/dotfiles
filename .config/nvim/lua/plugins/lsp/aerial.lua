local open_on_ft = {
	"markdown",
	"yaml",
	"json",
}
return {
	"stevearc/aerial.nvim",
	ft = open_on_ft,
	enabled = true,
	keys = {
		{ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = "LazyFile",
	opts = {
		layout = {
			default_direction = "prefer_left",
			width = 0.4,
		},
		close_automatic_events = {
			"switch_buffer",
		},
		autojump = true,
		attach_mode = "global",

		open_automatic = function(bufnr)
			local aerial = require("aerial")

			local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
			return vim.tbl_contains(open_on_ft, ft) and not aerial.was_closed()
		end,
	},
}
-- return {
-- 	"hedyhli/outline.nvim",
-- 	lazy = true,
-- 	cmd = { "Outline", "OutlineOpen" },
-- 	keys = { -- Example mapping to toggle outline
-- 		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
-- 	},
-- 	ft = { "markdown" },
-- 	opts = function()
-- 		return {
-- 			outline_window = {
-- 				width = 40,
-- 				relative_width = false,
-- 				focus_on_open = false,
-- 			},
-- 			outline_items = {
-- 				items = {},
-- 			},
-- 			symbol_folding = {
-- 				autofold_depth = 1,
-- 				auto_unfold = {
-- 					only = 2,
-- 				},
-- 			},
-- 			symbols = {
-- 				icon_fetcher = function(kind, bufnr)
-- 					local kinds = require("config.ui.kinds")
--
-- 					local ft = vim.api.nvim_get_option_value("ft", { buf = bufnr })
-- 					if ft == "markdown" then
-- 						return ""
-- 					end
--
-- 					if kinds[kind] == nil then
-- 						return false
-- 					end
--
-- 					return kinds[kind]
-- 				end,
-- 			},
-- 		}
-- 	end,
-- 	config = function(_, opts)
-- 		local outline = require("outline")
-- 		outline.setup(opts)
-- 	end,
-- }
