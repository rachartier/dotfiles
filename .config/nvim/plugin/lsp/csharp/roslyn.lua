vim.pack.add({ "https://github.com/seblyng/roslyn.nvim" }, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs", "vb" },
  once = true,
  callback = function()
    require("roslyn").setup({ filewatching = "auto" })
  end,
})
