local utils = require("utils")
local M = {
	cache = {},
}

function M.hl_group(name, buf)
	return vim.api.nvim_buf_get_name(buf):find("kinds") and "LspKind" .. name or name
end

return {
	{
		"echasnovski/mini.splitjoin",
		version = false,
		event = { "InsertEnter" },
		opts = {
			-- Module mappings. Use `''` (empty string) to disable one.
			-- Created for both Normal and Visual modes.
			mappings = {
				toggle = "gS",
				split = "",
				join = "",
			},
		},
	},
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.hipatterns",
		enabled = false,
		event = { "VeryLazy" },
		config = function()
			local hipatterns = require("mini.hipatterns")

			hipatterns.setup({
				highlighters = {
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
					hl_group = {
						pattern = function(buf)
							return vim.api.nvim_buf_get_name(buf):find("lua/" .. M.module)
								and '^%s*%[?"?()[%w%.@]+()"?%]?%s*='
						end,
						group = function(buf, match)
							local group = M.hl_group(match, buf)
							print(group)
							if group then
								if M.cache[group] == nil then
									M.cache[group] = false
									local hl = vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
									if not vim.tbl_isempty(hl) then
										hl.fg = hl.fg or vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
										M.cache[group] = true
										vim.api.nvim_set_hl(0, group .. "Dev", hl)
									end
								end
								return M.cache[group] and group .. "Dev" or nil
							end
						end,
						extmark_opts = { priority = 2000 },
					},

					hl_color = {
						pattern = {
							"%f[%w]()c%.[%w_%.]+()%f[%W]",
							"%f[%w]()colors%.[%w_%.]+()%f[%W]",
							"%f[%w]()vim%.g%.terminal_color_%d+()%f[%W]",
						},
						group = function(_, match)
							local parts = vim.split(match, ".", { plain = true })
							local color = vim.tbl_get(M.globals, unpack(parts))
							return type(color) == "string"
								and require("mini.hipatterns").compute_hex_color_group(color, "fg")
						end,
						extmark_opts = function(_, _, data)
							return {
								virt_text = { { "⬤ ", data.hl_group } },
								virt_text_pos = "inline",
								priority = 2000,
							}
						end,
					},
				},
			})
		end,
	},
	{
		"echasnovski/mini.align",
		event = { "VeryLazy" },
		opts = {},
	},
	{
		"echasnovski/mini.indentscope",
		event = { "VeryLazy" },
		init = function()
			utils.on_event("FileType", function()
				---@diagnostic disable-next-line: inject-field
				vim.b.miniindentscope_disable = true
			end, {
				target = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"dapui_stacks",
					"toggleterm",
					"lazyterm",
					"fzf",
					"spectre_panel",
				},
				desc = "Disable mini.indentscope",
			})
		end,
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
				options = {
					indent_at_cursor = true,
					try_as_border = true,
					border = "top",
				},
				symbol = "╎",
			})
		end,
	},
	{
		"echasnovski/mini.cursorword",
		event = { "VeryLazy" },
		version = false,
		opts = {},
	},
}
