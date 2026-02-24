local M = {}

function M.setup()
  local notify = require("mini.notify")
  notify.setup({
    lsp_progress = { enable = false },
    render = "compact",
    timeout = 3000,
    max_width = function()
      return math.floor(vim.api.nvim_win_get_width(0) * 0.75)
    end,
  })
end

return M
