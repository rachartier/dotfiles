--[[
-- Winbar configuration from https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/winbar.lua
-- Thanks MariaSolOs!
--]]

local folder_icon = require("config.ui.signs").others.folder
local M = {}

function M.render()
	local path = vim.fs.normalize(vim.fn.expand("%:p") --[[@as string]])

	-- No special styling for diff views.
	if vim.startswith(path, "diffview") then
		return string.format("%%#Winbar#%s", path)
	end

	local separator = " %#WinbarSeparator#  "

	local prefix, prefix_path = "", ""

	-- If the window gets too narrow, keep the last 3 path
	if vim.api.nvim_win_get_width(0) < 100 then
		local segments = vim.split(path, "/")
		if #segments > 3 then
			path = " " .. separator .. table.concat(segments, "/", #segments - 2)
		end
	else
		-- For some special folders, add a prefix instead of the full path (making
		-- sure to pick the longest prefix).
		---@type table<string, string>
		local special_dirs = {
			DOTFILES = vim.g.path_dotfiles,
			HOME = vim.env.HOME,
			WORK = vim.g.path_dev,
		}

		for dir_name, dir_path in pairs(special_dirs) do
			if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
				prefix, prefix_path = dir_name, dir_path
			end
		end
		if prefix ~= "" then
			path = path:gsub("^" .. prefix_path, "")
			prefix = string.format("%%#WinBarDir#%s%s", prefix, separator)
		end
	end

	-- Remove leading slash.
	path = path:gsub("^/", "")

	return table.concat({
		prefix,
		table.concat(
			vim.iter(vim.split(path, "/"))
				:map(function(segment)
					if segment == vim.fn.fnamemodify(path, ":t") then
						local filename = segment
						local extension = vim.fn.fnamemodify(filename, ":e")
						local ok, mini_icons = pcall(require, "mini.icons")

						if ok then
							local icon = mini_icons.get("filetype", extension)
							return string.format("%%#WinbarFile#%s %s", icon, segment)
						else
							return string.format("%%#WinbarFile#%s", segment)
						end
					end
					return string.format("%%#Winbar#%s", segment)
				end)
				:totable(),
			separator
		),
	})
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("custom_winbar", { clear = true }),
	desc = "Attach winbar",
	callback = function(args)
		local buf = args.buf
		local win = 0

		local name = vim.api.nvim_buf_get_name(buf)
		local config = vim.api.nvim_win_get_config(win)

		if
			not config.zindex -- Not a floating window
			and vim.bo[buf].buftype == "" -- Normal buffer
			and name ~= "" -- Has a file name
			and not vim.wo[win].diff -- Not in diff mode
			and not name:lower():find("git") -- Not in git diff
		then
			vim.wo[win].winbar = "%{%v:lua.require'custom.winbar'.render()%}"
		else
			vim.wo.winbar = ""
		end
	end,
})

return M
