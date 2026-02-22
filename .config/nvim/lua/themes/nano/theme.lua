local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#2E3440",
    mantle = "#3B4252",
    surface = "#434C5E",
    muted = "#4C566A",
    subtle = "#677691",
    text = "#ECEFF4",
    subtext = "#E5E9F0",
    highlight = "#FFFFFF",
    red = "#BF616A",
    peach = "#D08770",
    yellow = "#EBCB8B",
    green = "#A3BE8C",
    teal = "#8FBCBB",
    blue = "#81A1C1",
    mauve = "#B48EAD",
    flamingo = "#D08770",
  }
  palette.validate(colors)
  return colors
end

return M
