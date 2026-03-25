vim.pack.add({
  { src = "https://github.com/nvim-orgmode/orgmode" },
}, { confirm = false })

vim.schedule(function()
  require("orgmode").setup({
    org_agenda_files = "~/.config/nvim/notes/**/*",
    org_default_notes_file = "~/.config/nvim/notes/refile.org",
  })

  vim.lsp.enable("org")
end)
