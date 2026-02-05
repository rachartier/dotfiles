local utils = require("utils")
return {
  {
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
    "rachartier/tiny-buffers-switcher.nvim",
    enabled = true,
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
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_interpo_string.nvim",
    "rachartier/tiny-interpo-string.nvim",
    enabled = false,
    ft = { "python", "cs" },
    config = function()
      require("tiny_interpo_string").setup()
    end,
  },
  {
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-code-action.nvim",
    "rachartier/tiny-code-action.nvim",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    -- event = "LazyFile",
    config = function()
      require("tiny-code-action").setup({
        -- backend = "difftastic",
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
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-glimmer.nvim",
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    -- "rachartier/tiny-glimmer.nvim",
    -- dependencies = {
    -- 	{
    -- 		"gbprod/yanky.nvim",
    -- 		opts = {
    -- 			highlight = {
    -- 				on_put = false,
    -- 				on_yank = false,
    -- 				timer = 150,
    -- 			},
    -- 		},
    -- 	},
    -- },
    --
    -- event = "VeryLazy",
    -- enabled = true,
    opts = {
      overwrite = {
        auto_map = false, -- Disable auto-mapping
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
        desc = "glimmer",
      },
      {
        ",n2",
        function()
          require("tiny-glimmer").search_next()
        end,
        desc = "glimmer",
      },
      {
        ",N2",
        function()
          require("tiny-glimmer").search_prev()
        end,
        desc = "glimmer",
      },
      {
        ",*2",
        function()
          require("tiny-glimmer").search_under_cursor()
        end,
        desc = "glimmer",
      },
      {
        ",p2",
        function()
          require("tiny-glimmer").paste()
        end,
        desc = "glimmer",
      },
      {
        ",u2",
        function()
          require("tiny-glimmer").undo()
        end,
        desc = "glimmer",
      },
      {
        "\\R2",
        function()
          require("tiny-glimmer").redo()
        end,
        desc = "glimmer",
      },
    },
  },
  {
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-inline-diagnostic.nvim",
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    enabled = true,
    -- commit = "0ac1133f0869730ced61b5f3c540748e29acca1a",
    config = function()
      -- vim.api.nvim_set_hl(0, "CursorLine", { bg = require("theme").get_colors().surface1, bold = false })
      require("tiny-inline-diagnostic").setup({
        -- preset = "powerline",
        transparent_bg = false,
        hi = {
          mixing_color = require("theme").get_colors().base,
        },
        options = {
          -- add_messages = false,
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

      -- require("tiny-inline-diagnostic").setup({
      -- 	signs = {
      -- 		left = "",
      -- 		right = "",
      -- 		diag = "■",
      -- 		arrow = "",
      -- 		up_arrow = "",
      -- 		vertical = "  │",
      -- 		vertical_end = "  └",
      -- 	},
      -- 	blend = { factor = 0 },
      -- 	hi = {
      -- 		background = "None",
      -- 	},
      -- 	options = {
      -- 		multilines = {
      -- 			enabled = true,
      -- 			always_show = true,
      -- 		},
      -- 	},
      -- })
      -- require("utils").on_event("ColorScheme", function()
      -- 	local mixin_color = require("theme").get_colors().base
      -- 	require("tiny-inline-diagnostic").change({
      -- 		factor = 0.22,
      -- 	}, {
      -- 		mixing_color = mixin_color,
      -- 	})
      -- end, {
      -- 	target = "*",
      -- 	desc = "Change color scheme for tiny-inline-diagnostic",
      -- })

      --
      -- vim.keymap.set("n", "<leader>dd", "<cmd>set background=light<CR>",
      --     { noremap = true, silent = true })
      -- vim.keymap.set("n", "<leader>tid", function()
      -- 	vim.o.background = "dark"
      -- 	require("tiny-inline-diagnostic").change_severities()
      -- end, { noremap = true, silent = true })
      -- vim.keymap.set("n", "<leader>de", "<cmd>set background=dark<CR>",
      --     { noremap = true, silent = true })
    end,
  },
  {
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-devicons-auto-colors.nvim",
    "rachartier/tiny-devicons-auto-colors.nvim",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    enabled = false,
    config = function()
      -- local colors = require("theme").get_colors()
      -- local colors = require("tokyonight.colors").setup()
      require("tiny-devicons-auto-colors").setup({
        -- colors = colors,
        autoreload = true,
        cache = { enabled = false },
      })

      require("tiny-devicons-auto-colors").apply()
    end,
  },
  -- {
  -- 	"mrcjkb/rustaceanvim",
  -- 	version = "^5", -- Recommended
  -- 	lazy = false, -- This plugin is already lazy
  -- },
  -- {
  --   "nvim-java/nvim-java",
  -- },
}
