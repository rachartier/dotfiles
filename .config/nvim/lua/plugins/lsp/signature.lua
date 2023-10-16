local M = {
    "ray-x/lsp_signature.nvim",
    enabled = false,
    event = "VeryLazy",
}

function M.config()
    local U = require("utils")

    require("lsp_signature").setup({
        hint_enable = false,
        hint_prefix = "󱙇 ",
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        floating_window = true,
        handler_opts = {
            border = U.default_border, -- double, rounded, single, shadow, none, or a table of borders
        },
        bind = false,         -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        noice = true,
    })
end

return M
