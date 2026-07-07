vim.pack.add({
  "https://github.com/folke/lazydev.nvim",
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  once = true,
  callback = function()
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/love2d/library", words = { "love" } },
      },
    })
  end,
})
