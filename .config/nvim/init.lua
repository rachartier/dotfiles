vim.g._start_time = vim.uv.hrtime()
vim.loader.enable()

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = "msg",
  },
})

require("config")

require("themes").set_theme("system")

require("set")

vim.defer_fn(function()
  require("config.diagnostic")
  require("remap")

  require("custom.copilot-commit-message")
  require("custom.auto-nohlsearch")
  require("custom.detect-indent")
  require("custom.commit-diff-split")
  require("custom.pack-clean")
  require("custom.todo-highlight")
  require("custom.copilot-note-tags")

  require("custom.winbar").setup()
  require("neovide")

  vim.api.nvim_set_hl(0, "Visual", { bg = require("themes").get_colors().surface, bold = false })

  vim.cmd("packadd nvim.undotree")
  vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "open undotree" })
end, 10)

require("custom.statuscol").setup()

vim.api.nvim_create_user_command("Theme", function(opts)
  require("themes").switch_theme(opts.args)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(require("themes").available())
  end,
})

require("autocmds")

vim.defer_fn(function()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end, 50)
