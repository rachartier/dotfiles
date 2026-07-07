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
  require("plugins.utils.mini.base16").setup()
end

function M.available()
  return theme_modules
end

return M
