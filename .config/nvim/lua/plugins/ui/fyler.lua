return {
  "A7Lavinraj/fyler.nvim",
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
    win = {
      border = require("config.ui.border").default_border,
      kind = "float",
    },
  },
}
