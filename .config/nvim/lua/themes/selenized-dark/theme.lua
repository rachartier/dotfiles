local M = {}
local palette = require("themes.palette")

function M.get_colors()
  local colors = {
    base = "#184956",
    mantle = "#103c48",
    surface = "#2d5b69",
    muted = "#72898f",
    subtle = "#adbcbc",
    text = "#cad8d9",
    subtext = "#adbcbc",
    highlight = "#f275be",
    red = "#fa5750",
    peach = "#ed8649",
    yellow = "#dbb32d",
    green = "#75b938",
    teal = "#41c7b9",
    blue = "#4695f7",
    mauve = "#af88eb",
    flamingo = "#f275be",
  }
  palette.validate(colors)
  return colors
end

return M
