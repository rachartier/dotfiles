vim.schedule(function()
  vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" }, { confirm = false })

  require("gitsigns").setup({
    signcolumn = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align",
      ignore_whitespace = false,
    },
    preview_config = {
      border = require("config.ui.border").default_border,
    },
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    signs_staged = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = vim.keymap.set

      local o = function(desc) return { buffer = bufnr, silent = true, desc = desc } end
      -- stylua: ignore start
      map("n", "]h", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
      end, o("next hunk"))
      map("n", "[h", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
      end, o("prev hunk"))
      map("n", "]H", function() gs.nav_hunk("last") end,                      o("last hunk"))
      map("n", "[H", function() gs.nav_hunk("first") end,                     o("first hunk"))
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>",            o("stage hunk"))
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>",            o("reset hunk"))
      map("n", "<leader>ghS",  gs.stage_buffer,                               o("stage buffer"))
      map("n", "<leader>ghu",  gs.undo_stage_hunk,                            o("undo stage hunk"))
      map("n", "<leader>ghR",  gs.reset_buffer,                               o("reset buffer"))
      map("n", "<leader>ghp",  gs.preview_hunk_inline,                        o("preview hunk inline"))
      map("n", "<leader>ghb",  function() gs.blame_line({ full = true }) end, o("blame line"))
      map("n", "<leader>ghB",  function() gs.blame() end,                     o("blame buffer"))
      map("n", "<leader>ghd",  gs.diffthis,                                   o("diff this"))
      map("n", "<leader>ghD",  function() gs.diffthis("~") end,               o("diff this ~"))
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",               o("select hunk"))
      -- stylua: ignore end
    end,
  })
end)
