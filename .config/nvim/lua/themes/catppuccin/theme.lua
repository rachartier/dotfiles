local M = {}

function M.get_colors()
  return require("catppuccin.palettes").get_palette(vim.g.catppuccin_flavour)
end

function M.get_lualine_colors()
  local c = M.get_colors()

  local lualine_colors = {
    -- bg = "#232639", --c.mantle,
    -- bg = U.lighten(c.base, 0.99),
    -- bg = c.mantle,
    bg = c.surface0,
    fg = c.subtext0,
    surface0 = c.surface0,
    yellow = c.yellow,
    flamingo = c.flamingo,
    cyan = c.sapphire,
    darkblue = c.mantle,
    green = c.green,
    orange = c.peach,
    violet = c.lavender,
    mauve = c.mauve,
    blue = c.blue,
    red = c.red,
  }

  return vim.tbl_extend("force", lualine_colors, c)
end

return M
