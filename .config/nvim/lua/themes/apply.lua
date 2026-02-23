local themes = require("themes")

require("mini.base16").setup({
  palette = themes.get_base16_palette(),
  use_cterm = true,
  plugins = { default = true },
})

require("themes.groups").override_hl(themes.get_colors())
