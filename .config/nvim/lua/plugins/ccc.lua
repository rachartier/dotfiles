local M = {
    "uga-rosa/ccc.nvim",
    event = { "BufEnter", "BufNewFile" },
}

function M.config()
    require("ccc").setup({
        highlighter = {
            auto_enable = true,
        },
    })
end

return M
