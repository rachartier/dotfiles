local M = {
    'uga-rosa/ccc.nvim' ,
}

function M.config()
    require("ccc").setup {
        highlighter = {
            auto_enable = true,
        },
    }
end

return M
