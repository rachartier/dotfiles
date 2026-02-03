return {
  "lewis6991/gitsigns.nvim",
  event = { "LazyFile" },
  enabled = true,
  keys = {
    { "<leader>h", "", "+Git Hunk", mode = { "n" } },
  },
  opts = {
    signcolumn = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      ignore_whitespace = false,
    },
    preview_config = {
      border = require("config.ui.border").default_border,
    },
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      -- delete = { text = "" },
      -- topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    -- signs = {
    -- 	add = { text = "▏" },
    -- 	delete = { text = "" },
    -- 	change = { text = "▏" },
    -- 	untracked = { text = "┆" },
    -- },
    -- signs_staged = {
    -- 	add = { text = "▏" },
    -- 	delete = { text = "" },
    -- 	change = { text = "▏" },
    -- 	untracked = { text = "┆" },
    -- },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "prev hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "last hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "first hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "preview hunk inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "blame line")
        map("n", "<leader>ghB", function() gs.blame() end, "blame buffer")
        map("n", "<leader>ghd", gs.diffthis, "diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "diff this ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "select hunk")
    end,
  },
}
