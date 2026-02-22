local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#ebebeb",
    mantle = "#ffffff",
    surface = "#cdcdcd",
    muted = "#878787",
    subtle = "#474747",
    text = "#282828",
    subtext = "#474747",
    highlight = "#dd0f9d",
    red = "#d6000c",
    peach = "#d04a00",
    yellow = "#c49700",
    green = "#1d9700",
    teal = "#00ad9c",
    blue = "#0064e4",
    mauve = "#7f51d6",
    flamingo = "#dd0f9d",
  }
  palette.validate(colors)
  return colors
end

return M
