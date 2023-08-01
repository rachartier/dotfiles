local M = {
    "stevearc/dressing.nvim",
}

function M.config()
    require("dressing").setup({
        win_options = {
            winblend = 0,
        },
    })
end

return M
