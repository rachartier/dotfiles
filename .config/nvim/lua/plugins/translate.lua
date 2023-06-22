local M = {
    "potamides/pantran.nvim",
}

function M.config()
    require("pantran").setup({
        default_engine = "google",
        command = {
            default_mode = "replace",
        },
    })

    local opts = { noremap = true, silent = true, expr = true }
    vim.keymap.set("n", "<leader>tr", require("pantran").motion_translate, opts)
    vim.keymap.set("x", "<leader>tr", require("pantran").motion_translate, opts)
end

return M
