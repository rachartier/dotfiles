return {
  "sphamba/smear-cursor.nvim",
  event = "LazyFile",
  enabled = not vim.g.neovide and os.getenv("TERM") ~= "kitty",
  -- enabled = true,
  priority = 10,
  config = function()
    require("smear_cursor").setup({
      hide_target_hack = true,
      legacy_computing_symbols_support = true,
      -- -- trailing_exponent = 0.3,
      -- -- trailing_stiffness = 0.5,
      -- stiffness = 0.5,
      -- -- stiffness = 0.6,
      -- trailing_stiffness = 0.25,
      -- -- trailing_exponent = 0.1,
      -- -- gamma = 1,
      min_horizontal_distance_smear = 10,
      min_vertical_distance_smear = 2,

      cursor_color = require("theme").get_colors().text,
      transparent_bg_fallback_color = require("theme").get_colors().base,
    })
  end,
}
