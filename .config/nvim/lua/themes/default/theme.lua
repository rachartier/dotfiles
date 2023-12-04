local M = {}

local U = require("utils")

function M.get_colors()
	-- blue    = "#005078"
	-- cyan    = "#007676"
	-- green   = "#015825"
	-- grey1   = "#0a0b10"
	-- grey2   = "#1c1d23"
	-- grey3   = "#2c2e33"
	-- grey4   = "#4f5258"
	-- magenta = "#4c0049"
	-- red     = "#5e0009"
	-- yellow  = "#6e5600"

	-- local default_cursor_hl = U.get_hl("Cursor")

	return {
		-- bg = "#232639", --c.mantle,
		-- bg = "None",
		-- fg = U.to_hex(default_cursor_hl.foreground),
		-- yellow = "#6e5600",
		-- cyan = "#007676",
		-- darkblue = "#2c2e33",
		-- green = "#015825",
		-- orange = "#4f5258",
		-- violet = "#4f5258",
		-- mauve = "#4c0049",
		-- blue = "#005078",
		-- red = "#5e0009",
	}
end

function M.get_lualine_colors()
	local c = M.get_colors()
	return c
end

function M.setup()
	vim.cmd([[colorscheme default]])

	local colors = M.get_colors()

	require("themes.groups").override_hl(colors)
	-- require("themes.groups").override_lsp_hl(colors)
end

return M
