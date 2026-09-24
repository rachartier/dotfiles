local M = {}

function M.to_base16(colors)
  return {
    base00 = colors.base,
    base01 = colors.mantle,
    base02 = colors.surface,
    base03 = colors.muted,
    base04 = colors.subtle,
    base05 = colors.text,
    base06 = colors.subtext,
    base07 = colors.highlight,
    base08 = colors.red,
    base09 = colors.peach,
    base0A = colors.yellow,
    base0B = colors.green,
    base0C = colors.teal,
    base0D = colors.blue,
    base0E = colors.mauve,
    base0F = colors.flamingo,
  }
end

return M
