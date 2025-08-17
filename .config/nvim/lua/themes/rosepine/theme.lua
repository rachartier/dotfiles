local M = {}
local base = require("themes.base_palette")

function M.get_colors()
  local colors = {
    base = "#191724",
    mantle = "#1f1d2e",
    crust = "#16141f",
    text = "#e0def4",
    subtext1 = "#908caa",
    subtext0 = "#6e6a86",
    overlay2 = "#524f67",
    overlay1 = "#403d52",
    overlay0 = "#21202e",
    surface2 = "#26233a",
    surface1 = "#1f1d2e",
    surface0 = "#191724",
    blue = "#31748f",
    lavender = "#c4a7e7",
    sapphire = "#9ccfd8",
    sky = "#9ccfd8",
    teal = "#95b1ac",
    green = "#95b1ac",
    yellow = "#f6c177",
    peach = "#f6c177",
    maroon = "#ebbcba",
    red = "#eb6f92",
    mauve = "#c4a7e7",
    pink = "#ebbcba",
    flamingo = "#ebbcba",
    rosewater = "#ebbcba",
  }
  base.validate(colors)
  return colors
end

return M
