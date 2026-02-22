require("config")

-- require("vim._core.ui2").enable({
--   enable = true,
-- })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy_file").lazy_file()
require("themes").set_theme("system")

require("lazy").setup({
  spec = {
    { import = "plugins.completion" },
    { import = "plugins.dap" },
    { import = "plugins.editing" },
    { import = "plugins.git" },
    { import = "plugins.ia" },
    { import = "plugins.lsp" },
    { import = "plugins.notes" },
    { import = "plugins.ui" },
    { import = "plugins.utils" },
    { import = "plugins.user_plugins" },
  },
  ui = {
    border = require("config.ui.border").default_border,
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    frequency = 3600, -- check for updates every hour
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "startify",
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "spellfile",
        "shada",
        "rplugin",
        -- replaced by vim-matchup
        "matchit",
        "matchparen",
      },
    },
  },
})

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
