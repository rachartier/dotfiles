local M = {}

local theme_modules = {
  catppuccin = "themes.catppuccin.theme",
  default = "themes.default.theme",
  nano = "themes.nano.theme",
  rosepine = "themes.rosepine.theme",
  selenized = "themes.selenized.theme",
}

local loaded = {}

M.current = "default"

function M.set_theme(name)
  if not theme_modules[name] then
    error("Theme not found: " .. name)
  end
  M.current = name
end

function M.get_colors()
  if not loaded[M.current] then
    loaded[M.current] = require(theme_modules[M.current])
  end
  return loaded[M.current].get_colors()
end

return M
