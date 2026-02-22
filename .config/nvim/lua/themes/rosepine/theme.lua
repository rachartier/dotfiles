local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#191724",
    mantle = "#1f1d2e",
    surface = "#26233a",
    muted = "#524f67",
    subtle = "#6e6a86",
    text = "#e0def4",
    subtext = "#908caa",
    highlight = "#ebbcba",
    red = "#eb6f92",
    peach = "#f6c177",
    yellow = "#f6c177",
    green = "#95b1ac",
    teal = "#9ccfd8",
    blue = "#31748f",
    mauve = "#c4a7e7",
    flamingo = "#ebbcba",
  }
  palette.validate(colors)
  return colors
end

return M
