local M = {}

function M.hex_to_rgb(c)
  if c == nil then
    return { 0, 0, 0 }
  end

  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = M.hex_to_rgb(background)
  local fg = M.hex_to_rgb(foreground)

  local blend_channel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
end

function M.darken(hex, amount, bg)
  local default_bg = require("themes").get_colors().base
  return M.blend(hex, bg or default_bg, amount)
end

function M.lighten(hex, amount, fg)
  local default_fg = require("themes").get_colors().text
  return M.blend(hex, fg or default_fg, amount)
end

function M.hl_str(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

return M
