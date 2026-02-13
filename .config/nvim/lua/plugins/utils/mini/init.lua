local indentscope = require("plugins.utils.mini.indentscope")

return {
  "nvim-mini/mini.nvim",
  version = false,
  specs = {
    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = indentscope.disabled_filetypes,
      callback = function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.miniindentscope_disable = true
      end,
      desc = "disable mini.indentscope",
    })

    local au_opts = {
      pattern = "MiniStarterOpened",
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    }
    vim.api.nvim_create_autocmd("User", au_opts)
  end,
  config = function()
    vim.schedule(function()
      require("mini.surround").setup()
      require("mini.align").setup()
      require("mini.jump2d").setup({})

      require("plugins.utils.mini.splitjoin").setup()
      -- require("plugins.utils.mini.clue").setup()
      require("plugins.utils.mini.indentscope").setup()
      require("plugins.utils.mini.ai").setup()
      require("plugins.utils.mini.icons").setup()
      require("plugins.utils.mini.pairs").setup()
    end)

    require("plugins.utils.mini.starter").setup()
  end,
}
