return {
  {
    "OXY3DEV/markview.nvim",
    enabled = false,
    ft = { "markdown", "quarto", "rmd", "Avante", "codecompanion" },
    lazy = true,
    opts = function(_, opts)
      local presets = require("markview.presets")

      opts = {
        experimental = {
          check_rtp = false,
        },
        max_length = 99999,
        preview = {
          filetypes = { "markdown", "quarto", "rmd", "Avante", "codecompanion" },
          ignore_buftypes = {},
          hybrid_modes = { "i" },
          modes = { "n", "no", "c", "i" },
          linewise_hybrid_mode = true,
        },

        yaml = {
          enable = false,
        },
        markdown = {
          headings = presets.headings.decorated,
          horizontal_rules = presets.horizontal_rules.thin,
          tables = presets.tables.rounded,
          code_blocks = {
            style = "block",
            icons = "mini",

            language_direction = "right",
            min_width = 60,
            pad_char = " ",
            pad_amount = 3,

            border_hl = "MarkviewCode",
            info_hl = "MarkviewCodeInfo",

            sign = true,
            sign_hl = nil,
          },
          list_items = {
            shift_width = 2,
            marker_minus = {
              indent_size = 3,
              add_padding = true,
              conceal_on_checkboxes = true,

              text = "•",
              hl = "MarkviewListItemMinus",
            },
          },
        },
        markdown_inline = {
          internal_links = {
            default = function(_, item)
              local special_links = {
                ["git"] = "󰊢 ",
                ["project"] = " ",
                ["todo"] = "󰒲 ",
                ["terminal"] = " ",
              }

              for link, icon in pairs(special_links) do
                if string.lower(item.label):find(link) then
                  return {
                    hl = "MarkviewSubscript",
                    icon = icon,
                  }
                end
              end

              return {
                hl = "MarkviewSubscript",
                icon = "󱗖 ",
              }
            end,
          },
          checkboxes = {
            enable = true,
            ["!"] = {
              hl = "MarkdownCheckboxImportant",
              text = "󱅶",
            },
            ["*"] = {
              hl = "MarkdownCheckboxIdea",
              text = "󰌵",
            },
            ["-"] = {
              hl = "MarkdownCheckboxSkipped",
              text = "",
            },
            ["/"] = {
              hl = "MarkviewCheckboxProgress",
              text = "",
            },
            ["?"] = {
              hl = "MarkdownCheckboxQuestion",
              scope_hl = "Normal",
              text = "",
            },
            checked = {
              hl = "MarkviewCheckboxChecked",
              text = "",
            },
            f = {
              hl = "MarkdownCheckboxFire",
              text = "󰈸",
            },
            i = {
              hl = "MarkdownCheckboxInfo",
              text = "",
            },
            n = {
              hl = "MarkdownCheckboxNo",
              text = "󰔑",
            },
            s = {
              hl = "MarkdownCheckboxStar",
              text = "",
            },
            unchecked = {
              hl = "MarkviewCheckboxUnchecked",
              text = "",
            },
            y = {
              hl = "MarkdownCheckboxYes",
              text = "󰔓",
            },
          },
        },
      }

      return opts
    end,
    config = function(_, opts)
      require("markview").setup(opts)

      require("markview").setup({
        markdown = {
          headings = { shift_width = 1 },
        },
      })

      local colors = require("theme").get_colors()
      vim.api.nvim_set_hl(0, "MarkviewCode", { bg = colors.surface0 })
      vim.api.nvim_set_hl(0, "MarkviewInlineCode", { bg = colors.surface0 })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    enabled = true,
  },
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
      vim.g.table_mode_corner = "|"
    end,
    enabled = true,
  },
}
