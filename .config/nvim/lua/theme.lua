local M = {}

local theme_manager = require("themes")

function M.setup()
  require("themes.groups").override_hl(theme_manager.get_colors())
end

function M.get_colors()
  return theme_manager.get_colors()
end

function M.get_lualine_colors()
  return theme_manager.get_colors()
end

function M.get_kirby_colors()
  local c = theme_manager.get_colors()
  return {
    n = c.red,
    i = c.green,
    v = c.blue,
    ["\022"] = c.blue,
    V = c.blue,
    c = c.mauve,
    no = c.red,
    s = c.peach,
    S = c.peach,
    ["\019"] = c.peach,
    ic = c.yellow,
    R = c.mauve,
    Rv = c.mauve,
    cv = c.red,
    ce = c.red,
    r = c.teal,
    rm = c.teal,
    ["r?"] = c.teal,
    ["!"] = c.red,
    t = c.red,
  }
end

return M
