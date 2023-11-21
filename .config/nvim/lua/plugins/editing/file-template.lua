local M = {
    "otavioschwanck/new-file-template.nvim",
}

function M.config()
    require("new-file-template").setup({
        disable_insert = false,
    })
end

return M
