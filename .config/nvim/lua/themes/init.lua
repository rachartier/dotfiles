local M = {}

local palette = require("themes.palette")

local theme_modules = {
  system = "themes.system.theme",
  default = "themes.default.theme",
  nano = "themes.nano.theme",
  rosepine = "themes.rosepine.theme",
  ["selenized-dark"] = "themes.selenized-dark.theme",
  ["selenized-black"] = "themes.selenized-black.theme",
  ["selenized-light"] = "themes.selenized-light.theme",
  ["selenized-white"] = "themes.selenized-white.theme",
}

local cache = {}

M.current = "system"

function M.set_theme(name)
  if not theme_modules[name] then
    error("Theme not found: " .. name)
  end
  M.current = name
end

local function load_colors(name)
  if not cache[name] then
    cache[name] = require(theme_modules[name]).get_colors()
  end
  return cache[name]
end

function M.get_colors()
  return load_colors(M.current)
end

function M.get_base16_palette()
  return palette.to_base16(load_colors(M.current))
end

function M.switch_theme(name)
  if not theme_modules[name] then
    error("Theme not found: " .. name)
  end
  M.current = name
  cache = {}
  package.loaded["themes.apply"] = nil
  require("themes.apply")
end

function M.reload_system_theme()
  local home = vim.env.HOME or os.getenv("HOME")
  if not home then
    return
  end

  local current_file = home .. "/.config/custom-themes/.current"
  local f = io.open(current_file, "r")
  if not f then
    return
  end
  local name = f:read("*l")
  f:close()
  if not name or name == "" then
    return
  end

  local theme_file = home .. "/.config/custom-themes/" .. name .. ".sh"
  f = io.open(theme_file, "r")
  if not f then
    return
  end
  local content = f:read("*a")
  f:close()

  for key, value in content:gmatch('export%s+COLOR_(%w+)="(#%x+)"') do
    vim.env["COLOR_" .. key] = value
  end

  cache = {}
  M.current = "system"
  package.loaded["themes.apply"] = nil
  require("themes.apply")
end

function M.available()
  return theme_modules
end

return M
