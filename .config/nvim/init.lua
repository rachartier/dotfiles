vim.g._start_time = vim.uv.hrtime()
vim.loader.enable()

require("config")

require("themes").set_theme("system")

require("neovide")
require("set")
require("custom.winbar").setup()
require("custom.statuscol").setup()

vim.defer_fn(function()
  require("config.diagnostic")
  require("remap")

  require("custom.copilot-commit-message")

  vim.api.nvim_set_hl(0, "Visual", { bg = require("theme").get_colors().surface, bold = false })

  vim.cmd("packadd nvim.undotree")
  vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "open undotree" })
end, 10)

vim.api.nvim_create_user_command("Theme", function(opts)
  require("themes").switch_theme(opts.args)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(require("themes").available())
  end,
})

require("autocmds")
require("custom.auto-nohlsearch")
require("custom.detect-indent")
require("custom.commit-diff-split")
require("custom.todo-highlight")
