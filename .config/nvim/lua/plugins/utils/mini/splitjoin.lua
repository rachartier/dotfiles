local M = {}

function M.setup()
  require("mini.splitjoin").setup({
    mappings = {
      toggle = "gS",
      split = "",
      join = "",
    },
  })
end

return M
