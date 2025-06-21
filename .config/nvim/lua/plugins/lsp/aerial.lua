local utils = require("utils")
local was_opened = {}
local width_limit = 130

local open_on_ft = {
  "markdown",
  "yaml",
  "json",
}
return {
  "stevearc/aerial.nvim",
  ft = open_on_ft,
  enabled = true,
  keys = {
    { "<leader>at", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "LazyFile",
  opts = {
    layout = {
      default_direction = "prefer_left",
      width = 0.4,
    },
    close_automatic_events = {
      "switch_buffer",
    },
    autojump = true,
    attach_mode = "global",

    open_automatic = function(bufnr)
      local aerial = require("aerial")

      local width = vim.o.columns
      if width < width_limit then
        return false
      end

      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      return vim.tbl_contains(open_on_ft, ft) and not aerial.was_closed()
    end,
  },
  config = function(_, opts)
    local aerial = require("aerial")

    aerial.setup(opts)

    utils.on_event({ "BufEnter", "VimResized" }, function()
      local width = vim.o.columns
      local bufnr = vim.api.nvim_get_current_buf()

      if width < width_limit then
        if aerial.is_open() then
          was_opened[bufnr] = true
          aerial.close()
        end
      else
        if not aerial.is_open() and was_opened[bufnr] then
          aerial.open()
          was_opened[bufnr] = nil
        end
      end
    end)
  end,
}
