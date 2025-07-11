local M = {}

-- M._theme = require("themes.base16.theme")
-- M._theme = require("themes.alabaster.theme")
-- M._theme = require("themes.default.theme")

M._theme = require("themes.catppuccin.theme")
-- M._theme = require("themes.rosepine.theme")
-- M._theme = require("themes.nano.theme")

function M.setup()
  -- M._theme = require("themes.alabaster.theme")
  -- M._theme = require("themes.nano.theme")
  if M._theme ~= nil and M._theme.setup ~= nil then
    M._theme.setup()
  end
end

function M.get_colors()
  if M._theme == nil then
    return {}
  end

  if M._theme.get_colors == nil then
    return {
      base = require("utils").get_hl("Normal", "bg"),
      text = require("utils").get_hl("Normal", "fg"),
    }
  end

  return M._theme.get_colors()
end

function M.get_lualine_colors()
  if M._theme == nil then
    return {}
  end

  if M._theme.get_lualine_colors == nil then
    return {}
  end

  return M._theme.get_lualine_colors()
end

function M.get_kirby_colors()
  if M._theme == nil then
    return {}
  end

  if M._theme.get_kirby_colors == nil then
    return {}
  end

  local colors = M.get_lualine_colors()

  return {
    n = colors.red,
    i = colors.green,
    v = colors.blue,
    [""] = colors.blue,
    V = colors.blue,
    c = colors.mauve,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    [""] = colors.orange,
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
