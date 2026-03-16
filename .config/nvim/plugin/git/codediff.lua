if vim.g.dotfile_config_type == "minimal" then
  return
end

vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" }, { confirm = false })

vim.api.nvim_create_user_command("CodeDiff", function(info)
  vim.api.nvim_del_user_command("CodeDiff")
  vim.cmd("CodeDiff " .. (info.args or ""))
end, { nargs = "?" })
