local signs = require("config.ui.signs")

return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  opts = {
    icons = {
      inlay = {
        loading = signs.others.loading,
        done = signs.others.checkmark,
        error = signs.others.error_x,
      },
    },
    contenttypes = {
      ["application/json"] = {
        ft = "kulala-json",
      },
      ["application/xml"] = {
        ft = "kulala-xml",
      },
      ["text/html"] = {
        ft = "kulala-html",
      },
    },

    default_view = "headers_body",
  },

  config = function(_, opts)
    require("kulala").setup(opts)

    vim.treesitter.language.register("json", "kulala-json")
    vim.treesitter.language.register("xml", "kulala-xml")
    vim.treesitter.language.register("html", "kulala-html")

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<CR>",
      "<cmd>lua require('kulala').run()<cr>",
      { noremap = true, silent = true, desc = "Execute the request" }
    )

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "[",
      "<cmd>lua require('kulala').jump_prev()<cr>",
      { noremap = true, silent = true, desc = "Jump to the previous request" }
    )
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "]",
      "<cmd>lua require('kulala').jump_next()<cr>",
      { noremap = true, silent = true, desc = "Jump to the next request" }
    )
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>i",
      "<cmd>lua require('kulala').inspect()<cr>",
      { noremap = true, silent = true, desc = "Inspect the current request" }
    )
  end,
}
