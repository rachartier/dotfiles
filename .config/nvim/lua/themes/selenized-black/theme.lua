local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#252525",
    mantle = "#181818",
    surface = "#3b3b3b",
    muted = "#777777",
    subtle = "#b9b9b9",
    text = "#dedede",
    subtext = "#b9b9b9",
    highlight = "#eb6eb7",
    red = "#ed4a46",
    peach = "#e67f43",
    yellow = "#dbb32d",
    green = "#70b433",
    teal = "#3fc5b7",
    blue = "#368aeb",
    mauve = "#a580e2",
    flamingo = "#eb6eb7",
  }
  palette.validate(colors)
  return colors
end

return M
