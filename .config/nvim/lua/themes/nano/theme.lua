local M = {}
local base = require("themes.base_palette")

function M.get_colors()
  local colors = {
    -- Background colors (darkest to lightest)
    base = "#191C25", -- nano_background_color (dark) / closest dark base
    mantle = "#242832", -- base1 (dark) - slightly lighter than base
    crust = "#2C333F", -- base2 (dark) - surface layer

    -- Surface colors
    surface0 = "#373E4C", -- base3 (dark) - elevated surfaces
    surface1 = "#434C5E", -- base4 (dark) - more elevated
    surface2 = "#4C566A", -- base5 (dark) - highest surface

    -- Overlay colors (for UI elements)
    overlay0 = "#677691", -- nano_veryfaded_color (dark)
    overlay1 = "#9099AB", -- base6 (dark)
    overlay2 = "#D8DEE9", -- base7 (dark)

    -- Text colors
    subtext0 = "#90A4AE", -- nano_faded_color (light theme equivalent)
    subtext1 = "#ECEFF4", -- nano_foreground_color (dark)
    text = "#FFFFFF", -- nano_strong_color (dark) - primary text

    -- Accent colors
    blue = "#42A5F5", -- blue from your theme
    lavender = "#AB47BC", -- magenta (closest to lavender)
    sapphire = "#81A1C1", -- nano_salient_color (dark)
    sky = "#26C6DA", -- cyan
    teal = "#26C6DA", -- cyan (reused as teal is similar)
    green = "#66BB6A", -- green
    yellow = "#E2C12F", -- yellow
    peach = "#D08770", -- nano_popout_color (dark)
    maroon = "#EF5350", -- red (darker variant)
    red = "#EF5350", -- red
    mauve = "#AB47BC", -- magenta (purple-ish)
    pink = "#AB47BC", -- magenta (closest available)
    flamingo = "#FFAB91", -- nano_popout_color (light)
    rosewater = "#EBCB8B", -- nano_critical_color (dark) - warm tone
  }
  base.validate(colors)
  return colors
end

return M
