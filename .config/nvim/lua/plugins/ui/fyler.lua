return {
  "A7Lavinraj/fyler.nvim",
  -- dir = "~/dev/nvim_plugins/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  enabled = false,
  keys = {
    {
      "<leader>te",
      "<cmd>Fyler kind=float<cr>",
      desc = "Open Fyler",
    },
  },
  ---@module 'fyler'
  ---@type FylerSetupOptions
  opts = {
    popup = {
      permission = {
        border = "rounded",
      },
    },
    views = {
      finder = {
        win = {
          border = require("config.ui.border").default_border,
          kind = "float",
          kinds = {
            float = {
              top = "12%",
              width = "30%",
              left = "35%",
            },
          },
          win_opts = {
            number = true,
          },
        },
      },
    },
  },
}
