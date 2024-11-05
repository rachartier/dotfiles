local M = {}

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

	--     #004c73 (Dark blue)
	-- #007373 (Dark cyan)
	-- #005523 (Dark green)
	-- #07080d (Dark grey1)
	-- #14161b (Dark grey2)
	-- #2c2e33 (Dark grey3)
	-- #4f5258 (Dark grey4)
	-- #470045 (Dark magenta)
	-- #590008 (Dark red)
	-- #6b5300 (Dark yellow)

	--     #a6dbff (Light blue)
	-- #8cf8f7 (Light cyan)
	-- #b3f6c0 (Light green)
	-- #eef1f8 (Light grey1)
	-- #e0e2ea (Light grey2)
	-- #c4c6cd (Light grey3)
	-- #9b9ea4 (Light grey4)
	-- #ffcaff (Light magenta)
	-- #ffc0b9 (Light red)
	-- #fce094 (Light yellow)
	-- local default_cursor_hl = U.get_hl("Cursor")

	return {
		bg = "None",
		mantle = "#07080d",
		crust = "#14161b",
		fg = "#4f5258",
		surface0 = "#2c2e33",
		yellow = "#6b5300",
		flamingo = "#6b5300",
		cyan = "#007373",
		darkblue = "#004c73",
		green = "#005523",
		orange = "#ffc0b9",
		violet = "#470045",
		mauve = "#470045",
		blue = "#a6dbff",
		red = "#590008",

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
	require("themes.groups").override_lsp_hl(colors)
end

return M
