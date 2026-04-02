local M = {}
local palette = require("themes.palette")

local MACCHIATO_BASE = "#24273a"

function M.get_colors()
  local function env(name, fallback)
    return vim.env["COLOR_" .. name] or fallback
  end

  local colors = {
    base = env("base", MACCHIATO_BASE),
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

  if colors.base:lower() == MACCHIATO_BASE then
    colors.crust     = "#181926"
    colors.lavender  = "#b7bdf8"
    colors.sapphire  = "#7dc4e4"
    colors.sky       = "#91d7e3"
    colors.maroon    = "#ee99a0"
    colors.pink      = "#f5bde6"
    colors.rosewater = "#f4dbd6"
    colors.surface0  = "#363a4f"
    colors.surface1  = "#494d64"
    colors.surface2  = "#5b6078"
    colors.overlay0  = "#6e738d"
    colors.overlay1  = "#8087a2"
    colors.overlay2  = "#939ab7"
    colors.subtext0  = "#a5adcb"
    colors.subtext1  = "#b8c0e0"
  end

  palette.validate(colors)
  return colors
end

return M
