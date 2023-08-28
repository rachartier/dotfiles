local M = {
    "tzachar/highlight-undo.nvim",
}

function M.config()
    require("highlight-undo").setup({})
end

return M
