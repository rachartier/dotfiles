return {
  "esmuellert/codediff.nvim",
  cond = vim.g.dotfile_config_type ~= "minimal",
  cmd = {
    "CodeDiff",
  },
}
