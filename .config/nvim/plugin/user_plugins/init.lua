-- tiny-buffers-switcher
vim.pack.add({ "https://github.com/rachartier/tiny-buffers-switcher.nvim" }, { confirm = false })
require("tiny-buffers-switcher").setup({
  picker = "buffer",
  window = { width = 0.3, height = 0.2 },
})

vim.keymap.set("n", "<Tab>", function()
  local ok, nes = pcall(require, "sidekick.nes")
  if ok and nes.have() then
    return require("sidekick").nes_jump_or_apply()
  end
  require("tiny-buffers-switcher").switcher()
end, { silent = true })

vim.keymap.set("n", "<S-Tab>", function()
  require("tiny-buffers-switcher").switcher()
end, { silent = true })

-- tiny-code-action
vim.schedule(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/rachartier/tiny-code-action.nvim",
  }, { confirm = false })

  require("tiny-code-action").setup({
    backend = "delta",
    picker = {
      "buffer",
      opts = { hotkeys = true, auto_preview = false, hotkeys_mode = "text_diff_based" },
    },
    backend_opts = {
      delta = {
        args = { "--config=" .. os.getenv("HOME") .. "/.config/git/gitconfig" },
      },
    },
  })
end)

-- tiny-glimmer
vim.schedule(function()
  vim.pack.add({ "https://github.com/rachartier/tiny-glimmer.nvim" }, { confirm = false })

  require("tiny-glimmer").setup({
    overwrite = {
      auto_map = false,
      search   = { enabled = true },
      paste    = { enabled = true },
      undo     = { enabled = true },
      redo     = { enabled = true },
    },
  })

  vim.keymap.set("n", ",uG", function() require("tiny-glimmer").toggle() end,              { silent = true, desc = "glimmer toggle" })
  vim.keymap.set("n", ",n2", function() require("tiny-glimmer").search_next() end,         { silent = true, desc = "glimmer search next" })
  vim.keymap.set("n", ",N2", function() require("tiny-glimmer").search_prev() end,         { silent = true, desc = "glimmer search prev" })
  vim.keymap.set("n", ",*2", function() require("tiny-glimmer").search_under_cursor() end, { silent = true, desc = "glimmer search under cursor" })
  vim.keymap.set("n", ",p2", function() require("tiny-glimmer").paste() end,               { silent = true, desc = "glimmer paste" })
  vim.keymap.set("n", ",u2", function() require("tiny-glimmer").undo() end,                { silent = true, desc = "glimmer undo" })
  vim.keymap.set("n", "\\R2", function() require("tiny-glimmer").redo() end,               { silent = true, desc = "glimmer redo" })
end)

-- tiny-inline-diagnostic
vim.schedule(function()
  vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }, { confirm = false })

  require("tiny-inline-diagnostic").setup({
    transparent_bg = false,
    hi = { mixing_color = require("theme").get_colors().base },
    options = {
      multilines = { enabled = true, always_show = false },
      virt_texts = { priority = 2048 },
    },
    disabled_ft = {},
  })

  vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
end)

vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" }, { confirm = false })
require("tiny-cmdline").setup({
  on_reposition = require("tiny-cmdline").adapters.blink,
})
