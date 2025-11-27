return {
  "esmuellert/vscode-diff.nvim",
  cond = vim.g.dotfile_config_type ~= "minimal",
  dependencies = { "MunifTanjim/nui.nvim" },
}
