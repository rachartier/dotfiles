if vim.g.dotfile_config_type == "minimal" then
  return
end

vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" }, { confirm = false })
