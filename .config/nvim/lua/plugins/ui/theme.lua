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
    enabled = true,
    opts = {
      flavour = vim.g.catppuccin_flavour, -- latte, frappe, macchiato, mocha
      transparent_background = not vim.env.TMUX_NEOGIT_POPUP,
      show_end_of_buffer = false,
      term_colors = true,
      auto_integrations = true,
      float = {
        transparent = true, -- enable transparent floating windows
        solid = true, -- use solid styling for floating windows, see |winborder|
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
          ok = { "italic" },
        },
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      styles = {
        comments = { "italic" },
        conditionals = {},
        -- loops = {},
        -- functions = {},
        -- keywords = { "bold" },
        -- strings = {},
        -- variables = {},
        -- numbers = {},
        -- booleans = {},
        -- properties = {},
        types = {},
        operators = {},
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = false,
    opts = {
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)

      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "ronisbr/nano-theme.nvim",
    enabled = false,
    init = function()
      vim.o.background = "dark" -- or "dark".
      vim.cmd.colorscheme("nano-theme")
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
        undercurl = true,
      })

      -- Warning
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
        undercurl = true,
      })

      -- Info
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
        undercurl = true,
      })

      -- Hint
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
        undercurl = true,
      })
    end,
  },
}
