local loaded = false

local function load()
  if loaded then return end
  loaded = true

  vim.g.vimwiki_list = {
    { path = "~/.config/nvim/notes/", syntax = "markdown", ext = ".md" },
  }
  vim.g.vimwiki_global_ext = 1
  vim.g.vimwiki_use_mouse  = 1

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
      vim.bo.filetype = "markdown"
    end,
    desc = "set vimwiki filetype to markdown",
  })

  vim.pack.add({
    "https://github.com/michal-h21/vimwiki-sync",
    "https://github.com/vimwiki/vimwiki",
  }, { confirm = false })

  vim.g.vimwiki_key_mappings = { table_mappings = 0 }

  vim.keymap.set("n", "<leader>nl", "<Plug>VimwikiNextLink", { silent = true, desc = "next vimwiki link" })
  vim.keymap.set("n", "<leader>pl", "<Plug>VimwikiPrevLink", { silent = true, desc = "prev vimwiki link" })
end

for _, key in ipairs({ "<leader>ww", "<leader>wt", "<leader>ws", "<leader>wi", "<leader>wI", "<leader>wr" }) do
  vim.keymap.set("n", key, function()
    load()
    vim.cmd("normal! " .. key)
  end, { silent = true })
end
