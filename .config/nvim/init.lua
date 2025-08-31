require("config")

-- Disable deprecation warnings
-- TODO: remove this when deprecation warnings are fixed for 0.12
vim.deprecate = function() end

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
require("themes").set_theme("catppuccin")

--
require("lazy").setup({
  spec = {
    { import = "plugins.completion" },
    { import = "plugins.dap" },
    { import = "plugins.editing" },
    { import = "plugins.git" },
    { import = "plugins.ia" },
    { import = "plugins.lsp" },
    { import = "plugins.motion" },
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

require("custom.winbar").setup()
require("neovide")
require("set")

vim.defer_fn(function()
  require("config.diagnostic")
  require("remap")

  require("custom.copilot-commit-message")

  -- Don't know why Visual do not accept "bold" settings in Catppuccin, so putting it here fix it
  vim.api.nvim_set_hl(0, "Visual", { bg = require("theme").get_colors().surface0, bold = false })
end, 10)

require("autocmds")

-- require("vim._extui").enable({})
