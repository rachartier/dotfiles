local M = {}

-- M._theme = require("themes.base16.theme")
-- M._theme = require("themes.alabaster.theme")
M._theme = require("themes.catppuccin.theme")
-- M._theme = require("themes.default.theme")

function M.setup()
	if M._theme ~= nil then
		M._theme.setup()
	end

	require("fwatch").watch("/tmp/tmux-theme.cache", {
		on_event = function()
			vim.schedule(function()
				M._theme.setup()
				require("tiny-devicons-auto-colors").apply({
					colors = M.get_colors(),
				})
			end)
		end,
	})
end

function M.get_colors()
	if M._theme == nil then
		return {}
	end
	return M._theme.get_colors()
end

function M.get_lualine_colors()
	if M._theme == nil then
		return {}
	end
	return M._theme.get_lualine_colors()
end

return M
