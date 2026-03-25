vim.pack.add({
  "https://github.com/yousefhadder/markdown-plus.nvim",
  "https://github.com/OXY2DEV/markview.nvim",
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto", "rmd", "Avante", "codecompanion" },
  once = true,
  callback = function()
    require("markdown-plus").setup({})

    require("markview").setup({
      experimental = { check_rtp = false },
      max_length = 99999,
      preview = {
        filetypes = { "markdown", "quarto", "rmd", "Avante", "codecompanion" },
        ignore_buftypes = { "nofile" },
      },
      yaml = { enable = false },
      markdown = {
        headings = require("markview.presets").headings.decorated,
        horizontal_rules = require("markview.presets").horizontal_rules.thin,
        tables = require("markview.presets").tables.rounded,
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
    })

    require("markview").setup({ markdown = { headings = { shift_width = 1 } } })

    local colors = require("theme").get_colors()
    vim.api.nvim_set_hl(0, "MarkviewCode", { bg = colors.surface })
    vim.api.nvim_set_hl(0, "MarkviewInlineCode", { bg = colors.surface })
  end,
})

-- vim-table-mode
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/dhruvasagar/vim-table-mode" }, { confirm = false })
    vim.g.table_mode_corner = "|"
  end,
})
