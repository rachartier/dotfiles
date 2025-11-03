local border = require("config.ui.border").default_border

return {
  prompt = " ",
  ui_select = true,
  matcher = {
    frecency = true,
  },
  reverse = true,
  formatters = {
    file = {
      filename_first = true,
    },
  },
  sources = {
    gh_issue = {
      layout = {
        width = 0.8,
        height = 0.8,
      },
    },
  },
  layout = {
    cycle = true,
    reverse = true,
    --- Use the default layout or vertical if the window is too narrow
    preset = function()
      return vim.o.columns >= 130 and "custom" or "vertical"
    end,
  },
  win = {
    input = {
      keys = {
        ["<Tab>"] = { "list_down", mode = { "n", "i" } },
        ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
        ["<Esc>"] = { "close", mode = { "n", "i" } },
      },
    },
    list = {
      keys = {
        ["<Tab>"] = { "list_down", mode = { "n", "i" } },
        ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
      },
    },
  },
  layouts = {
    custom = {
      layout = {
        box = "horizontal",
        backdrop = false,
        width = vim.g.float_width,
        height = vim.g.float_height,
        border = "none",
        {
          box = "vertical",
          { win = "list", title = " Results ", title_pos = "center", border = border },
          {
            win = "input",
            height = 1,
            border = border,
            title = "{source} {live}",
            title_pos = "center",
          },
        },
        {
          win = "preview",
          width = 0.50,
          border = border,
          title = " Preview ",
          title_pos = "center",
        },
      },
    },
    vertical = {
      layout = {
        backdrop = false,
        width = vim.g.float_width,
        height = vim.g.float_height,
        box = "vertical",
        border = border,
        title_pos = "center",
        { win = "list", border = "none" },
        { win = "input", height = 1, border = "top" },
      },
    },
  },
}
