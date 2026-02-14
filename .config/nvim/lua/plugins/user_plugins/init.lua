return {
  {
    "rachartier/tiny-buffers-switcher.nvim",
    priority = 1000,
    keys = {
      {
        "<Tab>",
        function()
          local ok, nes = pcall(require, "sidekick.nes")

          if ok and nes.have() then
            return require("sidekick").nes_jump_or_apply()
          end

          require("tiny-buffers-switcher").switcher()
        end,
        { noremap = true, silent = true },
      },
      {
        "<S-Tab>",
        function()
          require("tiny-buffers-switcher").switcher()
        end,
        { noremap = true, silent = true },
      },
    },
    opts = {
      picker = "buffer",
      window = {
        width = 0.3,
        height = 0.2,
      },
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    config = function()
      require("tiny-code-action").setup({
        backend = "delta",
        picker = {
          "buffer",
          opts = {
            hotkeys = true,
            auto_preview = false,
            hotkeys_mode = "text_diff_based",
          },
        },
        backend_opts = {
          delta = {
            args = {
              "--config=" .. os.getenv("HOME") .. "/.config/git/gitconfig",
            },
          },
        },
      })
    end,
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {
      overwrite = {
        auto_map = false,
        search = { enabled = true },
        paste = { enabled = true },
        undo = { enabled = true },
        redo = { enabled = true },
      },
    },
    keys = {
      {
        ",uG",
        function()
          require("tiny-glimmer").toggle()
        end,
        desc = "glimmer toggle",
      },
      {
        ",n2",
        function()
          require("tiny-glimmer").search_next()
        end,
        desc = "glimmer search next",
      },
      {
        ",N2",
        function()
          require("tiny-glimmer").search_prev()
        end,
        desc = "glimmer search prev",
      },
      {
        ",*2",
        function()
          require("tiny-glimmer").search_under_cursor()
        end,
        desc = "glimmer search under cursor",
      },
      {
        ",p2",
        function()
          require("tiny-glimmer").paste()
        end,
        desc = "glimmer paste",
      },
      {
        ",u2",
        function()
          require("tiny-glimmer").undo()
        end,
        desc = "glimmer undo",
      },
      {
        "\\R2",
        function()
          require("tiny-glimmer").redo()
        end,
        desc = "glimmer redo",
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    config = function()
      require("tiny-inline-diagnostic").setup({
        transparent_bg = false,
        hi = {
          mixing_color = require("theme").get_colors().base,
        },
        options = {
          multilines = {
            enabled = true,
            always_show = false,
          },
          virt_texts = {
            priority = 2048,
          },
        },
        disabled_ft = {},
      })

      vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
    end,
  },
}
