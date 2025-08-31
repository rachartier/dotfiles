local M = {}

local themes = {
  catppuccin = require("themes.catppuccin.theme"),
  default = require("themes.default.theme"),
  nano = require("themes.nano.theme"),
  rosepine = require("themes.rosepine.theme"),
}

M.current = "default"

function M.set_theme(name)
  if not themes[name] then
    error("Theme not found: " .. name)
  end
  M.current = name
end

function M.get_colors()
  return themes[M.current].get_colors()
end

return M
