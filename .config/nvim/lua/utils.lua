local M = {}

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

function M.get_hl(group, attr)
  local hl = vim.api.nvim_get_hl(0, { name = group })
  return hl[attr]
end

function M.close_if_last_window(buf_name)
  local current_win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(current_win).relative ~= "" then
    return
  end

  local current_tab = vim.api.nvim_get_current_tabpage()
  local normal_windows = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(current_tab))

  local window_count = #normal_windows
  if window_count ~= 1 and window_count ~= 2 then
    return
  end

  local function get_window_filetypes(windows)
    local types = {}
    for _, win in ipairs(windows) do
      local bufnr = vim.api.nvim_win_get_buf(win)
      table.insert(types, vim.bo[bufnr].filetype)
    end
    return types
  end

  local filetypes = get_window_filetypes(normal_windows)

  local function should_close()
    if window_count == 1 then
      return filetypes[1] == buf_name
    end

    local has_buf_name = filetypes[1] == buf_name or filetypes[2] == buf_name

    return has_buf_name
  end

  if should_close() then
    vim.cmd("qa!")
  end
end

function M.hl_str(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

M._installed = nil ---@type table<string,boolean>?
M._queries = {} ---@type table<string,boolean>

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed, M._queries = {}, {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
      M._installed[lang] = true
    end
  end
  return M._installed or {}
end

---@param what string|number|nil
---@param query? string
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
function M.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or M.get_installed()[lang] == nil then
    return false
  end
  if query and not M.have_query(lang, query) then
    return false
  end
  return true
end

---@param lang string
---@param query string
function M.have_query(lang, query)
  local key = lang .. ":" .. query
  if M._queries[key] == nil then
    M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._queries[key]
end

return M
