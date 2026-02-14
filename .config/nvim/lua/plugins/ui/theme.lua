local function get_custom_theme_palette()
  local current = require("themes").current
  if current ~= "catppuccin" then
    return require("theme").get_colors()
  end

  return {}
end

return {
  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = vim.g.catppuccin_flavour,
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      auto_integrations = true,
      float = {
        transparent = true,
        solid = true,
      },
      color_overrides = {
        [vim.g.catppuccin_flavour or "macchiato"] = get_custom_theme_palette(),
      },
      highlight_overrides = {
        all = function(colors)
          return require("themes.groups").get(colors)
        end,
      },
      lsp_styles = {
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
        inlay_hints = {
          background = true,
        },
      },
      styles = {
        comments = { "italic" },
        conditionals = {},
        types = {},
        operators = {},
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
