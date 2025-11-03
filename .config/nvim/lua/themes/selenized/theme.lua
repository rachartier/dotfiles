-- Catppuccin color names matched to Selenized hex colors
-- Mocha flavor as reference

local M = {}
local base = require("themes.base_palette")

local themes = {
  dark = {
    rosewater = 0xf275be,
    flamingo = 0xf275be,
    pink = 0xf275be,
    mauve = 0xaf88eb,
    red = 0xfa5750,
    maroon = 0xfa5750,
    peach = 0xed8649,
    yellow = 0xdbb32d,
    green = 0x75b938,
    teal = 0x41c7b9,
    cyan = 0x41c7b9,
    sky = 0x4695f7,
    blue = 0x4695f7,
    sapphire = 0x4695f7,
    lavender = 0xaf88eb,

    text = 0xcad8d9,
    subtext1 = 0xadbcbc,
    subtext0 = 0x72898f,
    overlay2 = 0x72898f,
    overlay1 = 0x72898f,
    overlay0 = 0x72898f,
    surface2 = 0xcad8d9,
    surface1 = 0xadbcbc,
    surface0 = 0x72898f,
    base = 0x184956,
    mantle = 0x2d5b69,
    crust = 0x103c48,
  },

  black = {
    rosewater = 0xeb6eb7,
    flamingo = 0xeb6eb7,
    pink = 0xeb6eb7,
    mauve = 0xa580e2,
    red = 0xed4a46,
    maroon = 0xed4a46,
    peach = 0xe67f43,
    yellow = 0xdbb32d,
    green = 0x70b433,
    teal = 0x3fc5b7,
    cyan = 0x3fc5b7,
    sky = 0x368aeb,
    blue = 0x368aeb,
    sapphire = 0x368aeb,
    lavender = 0xa580e2,

    text = 0xdedede,
    subtext1 = 0xb9b9b9,
    subtext0 = 0x777777,
    overlay2 = 0x777777,
    overlay1 = 0x777777,
    overlay0 = 0x777777,
    surface2 = 0xdedede,
    surface1 = 0xb9b9b9,
    surface0 = 0x777777,
    base = 0x252525,
    mantle = 0x3b3b3b,
    crust = 0x181818,
  },

  light = {
    rosewater = 0xca4898,
    flamingo = 0xca4898,
    pink = 0xca4898,
    mauve = 0x8762c6,
    red = 0xd2212d,
    maroon = 0xd2212d,
    peach = 0xc25d1e,
    yellow = 0xad8900,
    green = 0x489100,
    teal = 0x009c8f,
    cyan = 0x009c8f,
    sky = 0x0072d4,
    blue = 0x0072d4,
    sapphire = 0x0072d4,
    lavender = 0x8762c6,

    text = 0x3a4d53,
    subtext1 = 0x53676d,
    subtext0 = 0x909995,
    overlay2 = 0x909995,
    overlay1 = 0x909995,
    overlay0 = 0x909995,
    surface2 = 0x3a4d53,
    surface1 = 0x53676d,
    surface0 = 0x909995,
    base = 0xece3cc,
    mantle = 0xd5cdb6,
    crust = 0xfbf3db,
  },

  white = {
    rosewater = 0xdd0f9d,
    flamingo = 0xdd0f9d,
    pink = 0xdd0f9d,
    mauve = 0x7f51d6,
    red = 0xd6000c,
    maroon = 0xd6000c,
    peach = 0xd04a00,
    yellow = 0xc49700,
    green = 0x1d9700,
    teal = 0x00ad9c,
    cyan = 0x00ad9c,
    blue = 0x0064e4,
    sapphire = 0x0064e4,
    lavender = 0x7f51d6,

    text = 0x282828,
    subtext1 = 0x474747,
    subtext0 = 0x878787,
    overlay2 = 0x878787,
    overlay1 = 0x878787,
    overlay0 = 0x878787,
    surface2 = 0x282828,
    surface1 = 0x474747,
    surface0 = 0x878787,
    base = 0xebebeb,
    mantle = 0xcdcdcd,
    crust = 0xffffff,
  },
}

function M.get_colors()
  local colors = themes.light
  local str_colors = {}

  for k, v in pairs(colors) do
    str_colors[k] = string.format("#%06x", v)
  end

  base.validate(str_colors)
  return str_colors
end

return M
