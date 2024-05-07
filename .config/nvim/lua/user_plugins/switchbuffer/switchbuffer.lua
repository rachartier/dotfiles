local M = {}

M.setup = function(options)
	M.opts = options

	-- vim.api.nvim_set_hl(0, "SwitchBufferModified", options.hl_modified or { link = "NeoTreeModified" })
	-- vim.api.nvim_set_hl(0, "SwitchBufferNormal", options.hl_normal or { link = "Normal" })
end

function M._get_filename_relative_path(fullpath, path_to_remove)
	fullpath = fullpath:gsub("\\", "/")
	path_to_remove = path_to_remove:gsub("\\", "/")

	fullpath = fullpath:gsub("/$", "")
	path_to_remove = path_to_remove:gsub("/$", "")

	local fullpath_len = #fullpath
	local path_to_remove_len = #path_to_remove

	local i = 1
	while i <= fullpath_len and i <= path_to_remove_len do
		if fullpath:sub(i, i) == path_to_remove:sub(i, i) then
			i = i + 1
		else
			break
		end
	end

	if i > path_to_remove_len then
		return fullpath:sub(i + 1)
	else
		return fullpath
	end
end

function M.get_symbol(filename)
	local devicons = pcall(require, "nvim-web-devicons")
	if not devicons then
		return "", nil
	end

	local ext = string.match(filename, "%.([^%.]*)$")

	if ext then
		ext = ext:gsub("%s+", "")
	end

	local symbol, hl = require("nvim-web-devicons").get_icon(filename, ext, { default = false })

	if symbol == nil then
		if filename:match("^term://") then
			symbol = " "
		else
			symbol = " "
		end
	end

	return symbol, hl
end

local function get_folders_in_path(path)
	local folders = {}

	for folder in path:gmatch("([^/]+)") do
		table.insert(folders, folder)
	end

	return folders
end

local function get_n_last_folders_in_path(path, n)
	local paths = get_folders_in_path(path)
	local nFolders = #paths

	if nFolders > n then
		local last = ""

		for i = n, 0, -1 do
			last = table.concat({ last, paths[nFolders - i] }, "/")
		end

		return string.sub(last, 2)
	else
		return path
	end
end

function M.format_filename(filename, filename_max_length)
	local function trunc_filename(fn, fn_max)
		if string.len(fn) <= fn_max then
			return fn
		end

		local substr_length = fn_max - string.len("...")
		if substr_length <= 0 then
			return string.rep(".", fn_max)
		end

		return "..." .. string.sub(fn, -substr_length)
	end

	filename = string.gsub(filename, "term://", "Terminal: ", 1)
	filename = get_n_last_folders_in_path(filename, 1)
	filename = trunc_filename(filename, filename_max_length)

	return filename
	-- return filename
end

function M._get_filename(fullpath)
	return fullpath:match("([^/]+)$")
end

M.get_list_buffers = function()
	local buffer_list = ""
	buffer_list = vim.fn.execute("ls t")

	local buf_names = vim.split(buffer_list, "\n")

	table.remove(buf_names, 1)

	if #buf_names >= 2 then
		local temp = buf_names[1]
		buf_names[1] = buf_names[2]
		buf_names[2] = temp
	end

	local buffer_names = {}
	for _, line in ipairs(buf_names) do
		local name = line:match('"([^"]+)"')
		local id = tonumber(line:match("([0-9]+) "))
		if name then
			local buf_modified = vim.api.nvim_buf_get_option(id, "modified")

			local path = name
			local formatted_filename = M.format_filename(path, 45)
			local icon, icon_color = M.get_symbol(path)
			local path_color = nil
			local status_color = nil
			local status_icon = ""
			local modified = false

			if buf_modified then
				-- path_color = "NeoTreeModified"
				modified = true
				status_icon = require("config.icons").signs.file.not_saved
				status_color = "SwitchBufferStatusColor"
			end

			if vim.fn.getbufvar(id, "bufpersist") ~= 1 then
				path_color = "Comment"
			end

			table.insert(buffer_names, {
				icon = icon,
				formatted_path = formatted_filename,
				path = path,
				icon_color = icon_color,
				path_color = path_color,
				status_icon = status_icon,
				status_color = status_color,
				filename = M._get_filename(path),
				filename_color = "Normal",
				modified = modified,
			})
		end
	end

	return buffer_names
end

local function fzf_switch()
	local builtin = require("fzf-lua.previewer.builtin")

	-- Inherit from the "buffer_or_file" previewer
	local buffer_previewer = builtin.buffer_or_file:extend()

	function buffer_previewer:new(o, opts, fzf_win)
		buffer_previewer.super.new(self, o, opts, fzf_win)
		setmetatable(self, buffer_previewer)
		return self
	end

	function buffer_previewer:parse_entry(entry_str)
		local path, line = entry_str:match("%s+(.*)")
		return {
			path = path,
			line = tonumber(line) or 1,
			col = 1,
		}
	end
	local fzf_lua = require("fzf-lua")

	fzf_lua.fzf_exec(function(fzf_cb)
		local buffers = M.get_list_buffers()

		for _, buffer in ipairs(buffers) do
			local path = buffer.path
			local modified = buffer.modified
			local status_icon = buffer.status_icon

			local color_icon = fzf_lua.utils.ansi_codes.red
			local line = string.format("   %s", path)

			if modified then
				line = string.format("%s %s", fzf_lua.utils.ansi_codes.red(status_icon), path)
			end

			fzf_cb(line)
		end

		fzf_cb()
	end, {
		previewer = buffer_previewer,
		prompt = "Buffers> ",
		cwd_prompt_shorten_val = 1,
		winopts = {
			width = 0.6,
			height = 0.6,
			row = 0.5, -- window row position (0=top, 1=bottom)
			col = 0.5,
		},
		actions = {
			["default"] = function(selected)
				if #selected > 0 then
					local buf = selected[1]:match("%s+(.*)")
					vim.cmd("buffer " .. buf)
				end
			end,
			["ctrl-d"] = function(selected)
				if #selected > 0 then
					local buf = selected[1]:match("%s+(.*)")
					vim.cmd("bdelete " .. buf[1])
				end
			end,
		},
		fn_transform = function(x)
			return require("fzf-lua").make_entry.file(x, { file_icons = true, color_icons = true })
		end,
	})
end

function M.select_buffers(opts)
	local telescope_ok = pcall(require, "telescope")

	if not telescope_ok then
		fzf_switch()
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local default_border = require("config.icons").default_border
	if default_border == "rounded" then
		default_border = require("config.icons").border.rounded_telescope
	end

	opts = opts
		or require("telescope.themes").get_dropdown({
			layout_strategy = "horizontal",
			borderchars = default_border,
			layout_config = {
				prompt_position = "top",
				horizontal = {
					width = 0.6,
					height = 0.6,
					preview_height = 0.6,
					preview_cutoff = 200,
				},
			},
			set_style = {
				result = {
					spacing = 0,
					indentation = 2,
					dynamic_width = true,
				},
			},
		})

	local function displayer(filename, picker)
		local display = require("telescope.pickers.entry_display").create({
			separator = " ",
			items = {
				{ width = 2 },
				{ width = 2 },
				{ width = #filename },
				{ remaining = true },
			},
		})
		return display(picker)
	end
	local make_display = function(entry)
		return displayer(entry.filename, {
			{ entry.icon, entry.icon_color },
			{ entry.status_icon, entry.status_color },
			{ entry.filename, entry.filename_color },
			{ entry.formatted_path, entry.path_color },
		})
	end

	local function create_finders_table()
		return finders.new_table({
			results = M.get_list_buffers(),
			entry_maker = function(entry)
				return {
					value = entry,
					ordinal = entry.path,
					path_color = entry.path_color,
					icon_color = entry.icon_color,
					formatted_path = entry.formatted_path,
					path = entry.path,
					icon = entry.icon,
					filename = entry.filename,
					filename_color = entry.filename_color,
					status_icon = entry.status_icon,
					status_color = entry.status_color,
					display = make_display,
				}
			end,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Navigate to a Buffer",
			finder = create_finders_table(),
			sorter = conf.generic_sorter(opts),
			previewer = require("telescope.config").values.file_previewer({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local selected = selection.value.path

					if selected ~= "" and selected ~= nil and selected ~= "[No Name]" then
						vim.cmd("buffer " .. selected)
					end
				end)

				map("i", "<Tab>", actions.move_selection_next)
				map("i", "<S-Tab>", actions.move_selection_previous)
				map("i", "<Esc>", actions.close)
				map("i", "<C-d>", function()
					local selection = action_state.get_selected_entry()
					local selected = selection.value.path

					if selected ~= "" and selected ~= nil and selected ~= "[No Name]" then
						vim.cmd("bdelete " .. selected)

						local current_picker = action_state.get_current_picker(prompt_bufnr)
						current_picker:refresh(create_finders_table(), {})
					end
				end)

				return true
			end,
		})
		:find()
end

return M
