local M = {}
local base = require("themes.base_palette")

function M.get_colors()
  local palette = require("catppuccin.palettes").get_palette(vim.g.catppuccin_flavour)
  base.validate(palette)
  return palette
end

return M
