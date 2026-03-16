if vim.g.dotfile_config_type == "minimal" then
  return
end

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/akinsho/flutter-tools.nvim",
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  once = true,
  callback = function()
    vim.defer_fn(function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
        },
        flutter_path = vim.fn.exepath("flutter") ~= "" and vim.fn.exepath("flutter")
          or "/opt/flutter/bin/flutter",
      })
    end, 50)
  end,
})
