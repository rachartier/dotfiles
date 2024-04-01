local M = {}

M.linter_config_folder = os.getenv("HOME") .. "/.config/linter-configs"

function M.length(table)
	local count = 0
	for _, _ in ipairs(table) do
		count = count + 1
	end
	return count
end

M.border_chars_round = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
M.border_chars_none = { "", "", "", "", "", "", "", "" }
M.border_chars_empty = { " ", " ", " ", " ", " ", " ", " ", " " }
M.border_chars_inner_thick = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" }
M.border_chars_outer_thick = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" }
M.border_chars_cmp_items = { "▛", "▀", "▀", " ", "▄", "▄", "▙", "▌" }
M.border_chars_cmp_doc = { "▀", "▀", "▀", " ", "▄", "▄", "▄", "▏" }
M.border_chars_outer_thin = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
M.border_chars_inner_thin = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" }
M.border_chars_outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" }
M.border_chars_outer_thick_telescope = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" }

-- M.default_border = M.border_chars_round
M.default_border = M.border_chars_outer_thin
-- M.default_border = M.border_chars_none

--M.top_right_corner_thin = "🭾"
--M.top_left_corner_thin = "🭽"

M.git_signs = {
	added = " ",
	modified = " ",
	removed = " ",
	-- added = " ",
	-- modified = " ",
	-- removed = " ",
}

M.signs = {
	file = {
		modified = "󱞁 ",
		not_saved = "󰉉 ",
	},
}

M.diagnostic_signs = {
	error = " ",
	warning = " ",
	info = " ",
	hint = " ",
	other = "󰠠 ",
}

-- M.diagnostic_signs = {
-- 	error = "●",
-- 	warning = "●",
-- 	info = "●",
-- 	hint = "●",
-- 	other = "●",
-- }

-- M.diagnostic_signs = {
--     error = " ",
--     warning = " ",
--     info = " ",
--     hint = "󱤅 ",
--     other = "󰠠 ",
-- }

M.diagnostic_signs.warn = M.diagnostic_signs.warning

M.kind_icons = {
	Text = " ",
	Method = " ",
	Function = "󰊕 ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = "󰏓 ",
	Property = " ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = " ",
	EnumMember = " ",
	Keyword = "󰌋 ",
	Snippet = " ",
	Color = " ",
	File = "󰈙 ",
	Reference = "󰈇 ",
	Folder = " ",
	Constant = "󰏿 ",
	Struct = "󰙅 ",
	Event = " ",
	Operator = " ",
	TypeParameter = "󰘦 ",
	Codeium = " ",
	Version = " ",
	Unknown = "  ",
}

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

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param myDebuggers string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
--- from: https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L27-L82
function M.tools_to_autoinstall(myLinters, myFormatters, myDebuggers, ignoreTools)
	-- get all linters, formatters, & debuggers and merge them into one list
	local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
	local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
	local tools = vim.list_extend(linterList, formatterList)
	vim.list_extend(tools, myDebuggers)

	-- only unique tools
	table.sort(tools)
	tools = vim.fn.uniq(tools)

	-- remove exceptions not to install
	tools = vim.tbl_filter(function(tool)
		return not vim.tbl_contains(ignoreTools, tool)
	end, tools)
	return tools
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

function M.hexToRgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = M.hexToRgb(background)
	local fg = M.hexToRgb(foreground)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
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

return M
