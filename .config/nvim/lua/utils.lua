local M = {}

M.linter_config_folder = os.getenv("HOME") .. "/.config/linter-configs"

function M.buffers_clean()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
			vim.cmd("bd " .. tostring(bufnr))
		end
	end
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

	local target = nil
	events = M.to_list(events)

	local group_name = ""

	if user_opts and user_opts.desc then
		group_name = "custom_" .. user_opts.desc:gsub(" ", "_"):lower() .. "_" .. group_index
	else
		group_name = "custom_" .. group_index
	end
	group_index = group_index + 1

	local group = vim.api.nvim_create_augroup(group_name, { clear = true })

	local opts = {
		callback = function(evt)
			callback(evt, group)
		end,
		group = group,
	}

	if user_opts then
		local valid_opts = { "target", "desc" }

		for key, _ in pairs(user_opts) do
			if not vim.tbl_contains(valid_opts, key) then
				error("Invalid option: " .. key)
			end
		end

		if user_opts.target then
			if type(user_opts.target) == "number" then
				target = user_opts.target
			else
				target = M.to_list(user_opts.target or nil)
			end
		end
		opts.desc = user_opts.desc or "Custom event"
	end

	if type(target) == "number" then
		opts.buffer = target
	elseif target then
		opts.pattern = target
	end

	vim.api.nvim_create_autocmd(events, opts)

	return group
end

return M
