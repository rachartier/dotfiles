local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local function env(name, fallback)
    return vim.env["COLOR_" .. name] or fallback
  end

  local colors = {
    base = env("base", "#24273a"),
    mantle = env("mantle", "#1e2030"),
    surface = env("surface", "#363a4f"),
    muted = env("muted", "#6e738d"),
    subtle = env("subtle", "#939ab7"),
    text = env("text", "#cad3f5"),
    subtext = env("subtext", "#b8c0e0"),
    highlight = env("highlight", "#b7bdf8"),
    red = env("red", "#ed8796"),
    peach = env("peach", "#f5a97f"),
    yellow = env("yellow", "#eed49f"),
    green = env("green", "#a6da95"),
    teal = env("teal", "#8bd5ca"),
    blue = env("blue", "#8aadf4"),
    mauve = env("mauve", "#c6a0f6"),
    flamingo = env("flamingo", "#f0c6c6"),
  }
  palette.validate(colors)
  return colors
end

return M
