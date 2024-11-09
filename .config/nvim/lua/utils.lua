local M = {}

M.linter_config_folder = os.getenv("HOME") .. "/.config/linter-configs"

function M.trim(str, opts)
	if not opts then
		return str
	end
	local res = str
	if opts.suffix then
		res = str:sub(#str - #opts.suffix + 1) == opts.suffix and str:sub(1, #str - #opts.suffix) or str
	end
	if opts.prefix then
		res = str:sub(1, #opts.prefix) == opts.prefix and str:sub(#opts.prefix + 1) or str
	end
	return res
end

function M.dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
	local ret = {} ---@type lsp.Client[]
	ret = vim.lsp.get_clients(opts)
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.on_rename(from, to)
	local clients = M.get_clients()
	for _, client in ipairs(clients) do
		if client.supports_method("workspace/willRenameFiles") then
			---@diagnostic disable-next-line: invisible
			local resp = client.request_sync("workspace/willRenameFiles", {
				files = {
					{
						oldUri = vim.uri_from_fname(from),
						newUri = vim.uri_from_fname(to),
					},
				},
			}, 1000, 0)
			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end
end

function M.hex_to_rgb(c)
	if c == nil then
		return { 0, 0, 0 }
	end

	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = M.hex_to_rgb(background)
	local fg = M.hex_to_rgb(foreground)

	local blend_channel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
end

function M.blend_bg(hex, amount)
	local default_bg = require("theme").get_colors().base
	return M.blend(hex, default_bg, amount)
end

function M.darken(hex, amount, bg)
	local default_bg = require("theme").get_colors().base
	return M.blend(hex, bg or default_bg, amount)
end

function M.lighten(hex, amount, fg)
	local default_fg = require("theme").get_colors().text
	return M.blend(hex, fg or default_fg, amount)
end

function M.directory_exists_in_root(directory_name, root)
	root = root or "."

	local path = root .. "/" .. directory_name
	local stat = vim.loop.fs_stat(path)
	return (stat and stat.type == "directory")
end

function M.read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

--- Converts a value to a list
---@param value any # any value that will be converted to a list
---@return any[] # the listified version of the value
function M.to_list(value)
	if value == nil then
		return {}
	elseif vim.islist(value) then
		return value
	elseif type(value) == "table" then
		local list = {}
		for _, item in ipairs(value) do
			table.insert(list, item)
		end

		return list
	else
		return { value }
	end
end

local group_index = 0

--- Creates an auto command that triggers on a given list of events
--- Inside user_opts, you can specify the target buffer or pattern like so: { target = 123 } or { target = "pattern" } or { target = { "pattern1", "pattern2" } }...
---@param events string|string[] # the list of events to trigger on
---@param callback function # the callback to call when the event is triggered
---@param user_opts table|nil # opts of the auto command
---@return number # the group id of the created group
function M.on_event(events, callback, user_opts)
	assert(type(callback) == "function")

	events = M.to_list(events)
	local group_name = user_opts
			and user_opts.desc
			and "custom_" .. user_opts.desc:gsub(" ", "_"):lower() .. "_" .. group_index
		or "custom_" .. group_index
	group_index = group_index + 1

	local group = vim.api.nvim_create_augroup(group_name, { clear = true })
	local opts = {
		callback = function(evt)
			callback(evt, group)
		end,
		group = group,
		desc = user_opts and user_opts.desc or "Custom event",
	}

	if user_opts then
		local valid_opts = { "target", "desc" }
		for key in pairs(user_opts) do
			assert(vim.tbl_contains(valid_opts, key), "Invalid option: " .. key)
		end

		local target = user_opts.target
		if target then
			if type(target) == "number" then
				opts.buffer = target
			else
				opts.pattern = M.to_list(target)
			end
		end
	end

	vim.api.nvim_create_autocmd(events, opts)
	return group
end

-- From: https://github.com/Wansmer/nvim-config/blob/76075092cf6a595f58d6150bb488b8b19f5d625a/lua/utils.lua#L50C1-L81C4
function M.char_on_pos(pos)
	pos = pos or vim.fn.getpos(".")
	return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
end

-- From: https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/4
function M.char_byte_count(s, i)
	if not s or s == "" then
		return 1
	end

	local char = string.byte(s, i or 1)

	-- Get byte count of unicode character (RFC 3629)
	if char > 0 and char <= 127 then
		return 1
	elseif char >= 194 and char <= 223 then
		return 2
	elseif char >= 224 and char <= 239 then
		return 3
	elseif char >= 240 and char <= 244 then
		return 4
	end
end

function M.get_visual_range()
	local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
	local er, ec = unpack(vim.fn.getpos("."), 2, 3)

	-- To correct work with non-single byte chars
	local byte_c = M.char_byte_count(M.char_on_pos({ er, ec }))
	ec = ec + (byte_c - 1)

	local range = {}

	if sr == er then
		local cols = sc >= ec and { ec, sc } or { sc, ec }
		range = { sr, cols[1] - 1, er, cols[2] }
	elseif sr > er then
		range = { er, ec - 1, sr, sc }
	else
		range = { sr, sc - 1, er, ec }
	end

	return range
end
-------------------------------

return M
