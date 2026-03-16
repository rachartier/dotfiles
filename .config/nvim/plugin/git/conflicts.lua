vim.pack.add({ "https://github.com/akinsho/git-conflict.nvim" }, { confirm = false })

vim.schedule(function()
  require("git-conflict").setup({
    disable_diagnostics = true,
    default_mappings = {
      ours = "o",
      theirs = "t",
      none = "0",
      both = "b",
      next = "n",
      prev = "p",
    },
  })
end)
