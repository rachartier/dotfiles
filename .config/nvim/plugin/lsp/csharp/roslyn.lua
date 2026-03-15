vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs", "vb" },
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/seblyng/roslyn.nvim" }, { confirm = false })
    require("roslyn").setup({ filewatching = "auto" })
  end,
})
