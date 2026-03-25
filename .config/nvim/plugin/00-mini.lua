vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" }, { confirm = false })

package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

local indentscope = require("plugins.utils.mini.indentscope")

vim.api.nvim_create_autocmd("FileType", {
  pattern = indentscope.disabled_filetypes,
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  desc = "disable mini.indentscope",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniStarterOpened",
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

require("plugins.utils.mini.base16").setup()

vim.schedule(function()
  require("mini.surround").setup()
  require("mini.align").setup()
  require("mini.jump2d").setup({})

  require("plugins.utils.mini.splitjoin").setup()
  require("plugins.utils.mini.indentscope").setup()
  require("plugins.utils.mini.ai").setup()
  require("plugins.utils.mini.icons").setup()
  require("plugins.utils.mini.pairs").setup()
  require("plugins.utils.mini.notify").setup()
  require("plugins.utils.mini.picker").setup()
  require("plugins.utils.mini.clue").setup()
end)

require("plugins.utils.mini.starter").setup()
