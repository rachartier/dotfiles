local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#24273a",
    mantle = "#1e2030",
    surface = "#363a4f",
    muted = "#494d64",
    subtle = "#5b6078",
    text = "#cad3f5",
    subtext = "#f4dbd6",
    highlight = "#b7bdf8",
    red = "#ed8796",
    peach = "#f5a97f",
    yellow = "#eed49f",
    green = "#a6da95",
    teal = "#8bd5ca",
    blue = "#8aadf4",
    mauve = "#c6a0f6",
    flamingo = "#f0c6c6",
  }
  palette.validate(colors)
  return colors
end

return M
