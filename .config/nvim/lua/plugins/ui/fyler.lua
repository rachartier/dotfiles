return {
  -- "A7Lavinraj/fyler.nvim",
  dir = "~/dev/nvim_plugins/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  keys = {
    {
      "<leader>te",
      "<Cmd>Fyler<CR>",
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
    win = {
      border = require("config.ui.border").default_border,
      kind = "float",
    },
  },
}
