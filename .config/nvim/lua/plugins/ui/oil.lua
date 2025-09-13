return {
  "stevearc/oil.nvim",
  enabled = false,
  -- keys = {
  --   {
  --     "<leader>te",
  --     "<Cmd>Oil --float<CR>",
  --     desc = "Open Oil",
  --   },
  -- },
  opts = {
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    cleanup_delay_ms = false,
    watch_for_changes = true,
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
    float = {
      get_win_title = nil,
      preview_split = "right",
      border = require("config.ui.border").default_border,

      max_width = math.floor(vim.o.columns * vim.g.float_width),
      max_height = math.floor(vim.o.lines * vim.g.float_height),

      override = function(conf)
        -- conf.height = math.floor(vim.o.lines * vim.g.float_height)
        -- conf.width = math.floor(vim.o.columns * vim.g.float_width)
        --
        -- conf.col = math.floor((vim.o.columns - conf.width) / 2)
        -- conf.row = math.floor((vim.o.lines - conf.height) / 2)

        return conf
      end,
    },
    keymaps = {
      ["<BS>"] = { "actions.parent", mode = "n" },
    },
  },
}
