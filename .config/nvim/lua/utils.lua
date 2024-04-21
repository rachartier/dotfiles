local M = {}

M.linter_config_folder = os.getenv("HOME") .. "/.config/linter-configs"

function M.length(table)
	local count = 0
	for _, _ in ipairs(table) do
		count = count + 1
	end
	return count
end

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

function M.add_missing(dst, src)
	for k, v in pairs(src) do
		if dst[k] == nil then
			dst[k] = v
		end
	end
	return dst
end

function M.to_hex(n)
	return string.format("#%06x", n)
end

function M.get_hl(name)
	return vim.api.nvim_get_hl_by_name(name, true)
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
	local ret = {} ---@type lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
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

function M.get_python_path(workspace)
	local util = require("lspconfig.util")
	local path = util.path

	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	for _, pattern in ipairs({ "*", ".*" }) do
		local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
		if match ~= "" then
			return path.join(path.dirname(match), "bin", "python")
		end
	end

	return vim.fn.executable("python3") == 1 or vim.fn.executable("python") == 1 or "python"
end

function M.copy_visual_selection()
	vim.cmd.normal({ '"zy', bang = true })
	local visual_selection = vim.fn.getreg("z")

	vim.fn.setreg("*", visual_selection)
	vim.fn.setreg("+", visual_selection)
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

function M.get_table_keys(tbl)
	local keys = {}
	for k, v in pairs(tbl) do
		if type(k) == "number" then
			table.insert(keys, v)
		else
			table.insert(keys, k)
		end
	end
	return keys
end

return M
