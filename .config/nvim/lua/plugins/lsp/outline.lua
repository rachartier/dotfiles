local utils = require("utils")

return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	ft = { "markdown" },
	opts = function()
		return {
			outline_window = {
				width = 40,
				relative_width = false,
				focus_on_open = false,
			},
			outline_items = {
				items = {},
			},
			symbol_folding = {
				autofold_depth = 1,
				auto_unfold = {
					only = 2,
				},
			},
			symbols = {
				icon_fetcher = function(kind, bufnr)
					local kinds = require("config.ui.kind")

					local ft = vim.api.nvim_get_option_value("ft", { buf = bufnr })
					if ft == "markdown" then
						return ""
					end

					if kinds[kind] == nil then
						return false
					end

					return kinds[kind]
				end,
			},
		}
	end,
	config = function(_, opts)
		local outline = require("outline")
		outline.setup(opts)

		-- utils.on_event("FileType", function(event)
		-- 	vim.schedule(function()
		-- 		vim.cmd("topleft Outline!")
		-- 	end)
		-- end, {
		-- 	target = { "markdown" },
		-- 	desc = "Outline for markdown",
		-- })
	end,
}
