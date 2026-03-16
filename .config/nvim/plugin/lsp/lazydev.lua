vim.pack.add({
  "https://github.com/Bilal2453/luvit-meta",
  "https://github.com/folke/lazydev.nvim",
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  once = true,
  callback = function()
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "${3rd}/love2d/library", words = { "love" } },
        {
          path = "/home/rachartier/.local/share/nvim/mason/packages/lua-language-server/libexec/meta/3rd/love2d",
          words = { "love" },
        },
      },
    })
  end,
})
