local M = {
    "ray-x/lsp_signature.nvim",
    enabled = false,
}

function M.config()
    require("lsp_signature").setup({
        noice = false,
        hint_enable = false,
        hint_prefix = "🔍 ",
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        handler_opts = {
            border = "rounded",                 -- double, rounded, single, shadow, none, or a table of borders
        },
        bind = true,                            -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
    })
end

return M
