local M = {
    "danymat/neogen",
}

function M.config()
    require("neogen").setup({
        languages = {
            cs = {
                template = {
                    annotation_convention = "xmldoc",
                },
            },
        },
    })

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<Leader>ng", ":lua require('neogen').generate()<CR>", opts)
end

return M
