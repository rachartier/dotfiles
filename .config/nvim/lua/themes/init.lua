local M = {}

local names = {
  "system",
  "default",
  "nano",
  "rosepine",
  "selenized-dark",
  "selenized-black",
  "selenized-light",
  "selenized-white",
}

M.current = "system"

function M.get_colors()
  return require("themes." .. M.current .. ".theme")
end

function M.get_base16_palette()
  return require("themes.palette").to_base16(M.get_colors())
end

function M.switch_theme(name)
  if not vim.list_contains(names, name) then
    error("Theme not found: " .. name)
  end
  M.current = name
  require("plugins.utils.mini.base16").setup()
end

function M.available()
  return names
end

return M
