local M = {}

function M.setup()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" },
    },
    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      config = {},
      delay = 100,
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
  })
end

return M
