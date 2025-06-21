return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  keys = {
    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>tq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
  opts = {
    icons = {
      kinds = require("config.ui.kinds"),
    },
  },
}
