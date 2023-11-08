local M = {}

-- M._theme = require("themes.base16.theme")
-- M._theme = require("themes.nano.theme")
M._theme = require("themes.catppuccin.theme")

function M.setup()
	M._theme.setup()
end

function M.get_colors()
	return M._theme.get_colors()
end

function M.get_lualine_colors()
	return M._theme.get_lualine_colors()
end

return M
