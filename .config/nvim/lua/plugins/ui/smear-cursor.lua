local colors = require("theme").get_colors()

return {
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {
			legacy_computing_symbols_support = true,
			normal_bg = colors.base,
			-- trailing_exponent = 0.3,
			-- trailing_stiffness = 0.5,
			stiffness = 0.5,
			-- stiffness = 0.6,
			trailing_stiffness = 0.2,
			-- trailing_exponent = 0.1,
			-- gamma = 1,
		},
	},
	{
		"karb94/neoscroll.nvim",
		event = "LazyFile",
		config = function()
			local neoscroll = require("neoscroll")
			neoscroll.setup({
				hide_cursor = false,
			})
			local keymap = {
				["<C-u>"] = function()
					neoscroll.ctrl_u({ duration = 80 })
				end,
				["<C-d>"] = function()
					neoscroll.ctrl_d({ duration = 80 })
				end,
				["<C-b>"] = function()
					neoscroll.ctrl_b({ duration = 100 })
				end,
				["<C-f>"] = function()
					neoscroll.ctrl_f({ duration = 100 })
				end,
				["<C-y>"] = function()
					neoscroll.scroll(-0.2, { move_cursor = false, duration = 80 })
				end,
				["<C-e>"] = function()
					neoscroll.scroll(0.2, { move_cursor = false, duration = 80 })
				end,
				["zt"] = function()
					neoscroll.zt({ half_win_duration = 80 })
				end,
				["zz"] = function()
					neoscroll.zz({ half_win_duration = 80 })
				end,
				["zb"] = function()
					neoscroll.zb({ half_win_duration = 80 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
}
