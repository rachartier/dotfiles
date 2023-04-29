local M = {
    "aserowy/tmux.nvim",
}

function M.config()
require("tmux").setup()
end

return M
