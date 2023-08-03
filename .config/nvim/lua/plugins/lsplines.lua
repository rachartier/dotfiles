local M = {
    "rachartier/mirror_lsp_lines.nvim",
}

function M.config()
    require("lsp_lines").setup({})
    -- Disable virtual_text since it's redundant due to lsp_lines.
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { highlight_whole_line = false },
    })
end

return M
