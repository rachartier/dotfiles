return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
    "brenoprata10/nvim-highlight-colors",
    "saghen/blink.compat",
  },
  -- build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" },
  -- lazy = false,
  opts = {
    keymap = {
      preset = "super-tab",
    },

    signature = { enabled = true },
    enabled = function()
      return not vim.tbl_contains({
        "Avante",
        "copilot-chat",
      }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end,

    completion = {
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      documentation = {
        -- border = "padded",
        -- border = require("config.ui.border").blink_empty,
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            if vim.fn.mode() == "c" and vim.fn.getcmdtype() == "/" then
              return { pos[1] - 1, pos[2] }
            end
            return { pos[1], pos[2] }
          end

          return { vim.o.lines + 1, 0 }
        end,
        draw = {
          treesitter = { "lsp" },
        },
      },
      trigger = {
        show_on_insert_on_trigger_character = false,
      },
    },
    fuzzy = {
      sorts = {
        "exact",
        -- defaults

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
        -- dont show LuaLS require statements when lazydev has items
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
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
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
            return true
          end
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
        require("copilot.suggestion").dismiss()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })

    -- vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
}
