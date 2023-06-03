local M = {
    'ray-x/lsp_signature.nvim',
    enabled = false,
}

function M.config()
    require "lsp_signature".setup({
        noice = true,
    })
end

return M
