local M = {}

-- This is the strict schema for all themes. All themes must provide these keys.
M.base_palette = {
  base = "",
  mantle = "",
  crust = "",
  text = "",
  subtext1 = "",
  subtext0 = "",
  overlay2 = "",
  overlay1 = "",
  overlay0 = "",
  surface2 = "",
  surface1 = "",
  surface0 = "",
  blue = "",
  lavender = "",
  sapphire = "",
  sky = "",
  teal = "",
  green = "",
  yellow = "",
  peach = "",
  maroon = "",
  red = "",
  mauve = "",
  pink = "",
  flamingo = "",
  rosewater = "",
}

-- Utility to validate a theme's color table
function M.validate(colors)
  for k, _ in pairs(M.base_palette) do
    if not colors[k] then
      error("Theme missing required color: " .. k)
    end
  end
  return true
end

return M
