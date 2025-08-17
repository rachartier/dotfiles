local M = {}

local theme_manager = require("themes")

function M.setup()
  require("themes.groups").override_hl(theme_manager.get_colors())
end

function M.get_colors()
  return theme_manager.get_colors()
end

function M.get_lualine_colors()
  local c = theme_manager.get_colors()
  local lualine_colors = {
    bg = c.surface0,
    fg = c.subtext0,
    surface0 = c.surface0,
    yellow = c.yellow,
    flamingo = c.flamingo,
    cyan = c.sapphire,
    darkblue = c.mantle,
    green = c.green,
    orange = c.peach,
    violet = c.lavender,
    mauve = c.mauve,
    blue = c.blue,
    red = c.red,
  }
  return vim.tbl_extend("force", lualine_colors, c)
end

function M.get_kirby_colors()
  local colors = M.get_lualine_colors()
  return {
    n = colors.red,
    i = colors.green,
    v = colors.blue,
    ["\022"] = colors.blue,
    V = colors.blue,
    c = colors.mauve,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    ["\019"] = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t = colors.red,
  }
end

return M
