local was_opened = {}
local width_limit = 130

local M = {}

local open_on_ft = {
  "markdown",
  "yaml",
  "json",
}

M.was_closed = false

local function quit_aerial()
  local aerial = require("aerial")
  if aerial.is_open() then
    aerial.close()
  end

  M.was_closed = true
end

return {
  "stevearc/aerial.nvim",
  ft = open_on_ft,
  enabled = false,
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

    on_attach = function(bufnr)
      vim.keymap.set("n", "q", quit_aerial, { buffer = bufnr, desc = "Quit Aerial" })
      vim.keymap.set("n", "<ESC>", quit_aerial, { buffer = bufnr, desc = "Quit Aerial" })
    end,

    open_automatic = function(bufnr)
      if M.was_closed then
        return false
      end

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

    vim.api.nvim_create_autocmd({ "BufEnter", "VimResized" }, {
      callback = function()
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
      end,
    })
  end,
}
