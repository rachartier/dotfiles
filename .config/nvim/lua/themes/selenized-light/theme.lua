local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#ece3cc",
    mantle = "#fbf3db",
    surface = "#d5cdb6",
    muted = "#909995",
    subtle = "#53676d",
    text = "#3a4d53",
    subtext = "#53676d",
    highlight = "#ca4898",
    red = "#d2212d",
    peach = "#c25d1e",
    yellow = "#ad8900",
    green = "#489100",
    teal = "#009c8f",
    blue = "#0072d4",
    mauve = "#8762c6",
    flamingo = "#ca4898",
  }
  palette.validate(colors)
  return colors
end

return M
