return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
    "saghen/blink.compat",
  },
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "super-tab",
    },

    signature = {
      enabled = true,
    },
    enabled = function()
      return not vim.tbl_contains({
        "Avante",
        "copilot-chat",
      }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end,

    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    -- cmdline = {
    --   completion = {
    --     list = { selection = { preselect = false } },
    --     menu = {
    --       auto_show = function(ctx)
    --         return vim.fn.getcmdtype() == ":"
    --       end,
    --     },
    --     ghost_text = { enabled = true },
    --   },
    -- },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      ghost_text = {
        enabled = false,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
    },
    fuzzy = {
      sorts = {
        "exact",
        "score",
        "sort_text",
        "label",
      },
    },

    sources = {
      default = function()
        local sources = {
          "copilot",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "lazydev",
          "avante_commands",
          "avante_mentions",
          "avante_files",
        }
        local ok, node = pcall(vim.treesitter.get_node)

        if ok and node then
          if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            table.insert(sources, "path")
          end
          if node:type() ~= "string" then
            table.insert(sources, "snippets")
          end
        end

        return sources
      end,
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 999999,
          async = true,
          opts = {
            max_completions = 3,
            max_attempts = 4,
          },
        },
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 90,
          opts = {},
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 100,
          opts = {},
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 1000,
          opts = {},
        },
      },
    },

    appearance = {
      kind_icons = require("config.ui.kinds"),
    },
  },
  config = function(_, opts)
    opts.keymap = {
      ["<Tab>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        "snippet_forward",
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
        function()
          return vim.lsp.inline_completion.get()
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      },
    }

    require("blink-cmp").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.lsp.inline_completion.enable(false)
      end,
      desc = "disable inline completion when blink menu opens",
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.lsp.inline_completion.enable(true)
      end,
      desc = "enable inline completion when blink menu closes",
    })
  end,
}
