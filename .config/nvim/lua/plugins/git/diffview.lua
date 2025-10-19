return {
  "sindrets/diffview.nvim",
  cond = vim.g.dotfile_config_type ~= "minimal",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewRefresh",
    "DiffviewLog",
    "DiffviewFileHistory",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },
  keys = {
    { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view open" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diff view close" },
  },
  opts = {},
}
