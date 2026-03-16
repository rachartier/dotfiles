local loaded = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    if not loaded then
      loaded = true

      local signs = require("config.ui.signs")

      vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" }, { confirm = false })

      require("kulala").setup({
        icons = {
          inlay = {
            loading = signs.others.loading,
            done    = signs.others.checkmark,
            error   = signs.others.error_x,
          },
        },
        contenttypes = {
          ["application/json"] = { ft = "kulala-json" },
          ["application/xml"]  = { ft = "kulala-xml" },
          ["text/html"]        = { ft = "kulala-html" },
        },
        default_view = "headers_body",
      })

      vim.treesitter.language.register("json", "kulala-json")
      vim.treesitter.language.register("xml", "kulala-xml")
      vim.treesitter.language.register("html", "kulala-html")
    end

    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>",      "<cmd>lua require('kulala').run()<cr>",        { noremap = true, silent = true, desc = "Execute the request" })
    vim.api.nvim_buf_set_keymap(buf, "n", "[",         "<cmd>lua require('kulala').jump_prev()<cr>",  { noremap = true, silent = true, desc = "Jump to previous request" })
    vim.api.nvim_buf_set_keymap(buf, "n", "]",         "<cmd>lua require('kulala').jump_next()<cr>",  { noremap = true, silent = true, desc = "Jump to next request" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>i", "<cmd>lua require('kulala').inspect()<cr>",   { noremap = true, silent = true, desc = "Inspect the current request" })
  end,
  desc = "load kulala for http files",
})
