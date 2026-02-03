return {
  "vimwiki/vimwiki",
  dependencies = {
    "michal-h21/vimwiki-sync",
  },
  keys = {
    "<leader>ww",
    "<leader>wt",
    "<leader>ws",
    "<leader>wi",
    "<leader>wI",
    "<leader>wr",
  },
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/.config/nvim/notes/",
        syntax = "markdown",
        ext = ".md",
      },
    }

    vim.g.vimwiki_global_ext = 1
    vim.g.vimwiki_use_mouse = 1

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vimwiki",
      callback = function()
        vim.o.filetype = "markdown"
      end,
      desc = "set vimwiki filetype to markdown",
    })
  end,
  config = function()
    vim.g.vimwiki_key_mappings = {
      table_mappings = 0,
    }

    vim.keymap.set("n", "<leader>nl", "<Plug>VimwikiNextLink", { silent = true, desc = "next vimwiki link" })
    vim.keymap.set("n", "<leader>pl", "<Plug>VimwikiPrevLink", { silent = true, desc = "prev vimwiki link" })
  end,
}
