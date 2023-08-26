local M = {
    "ray-x/lsp_signature.nvim",
    enabled = true,
}

function test(a, b, c) end

function M.config()
    local U = require("utils")

    require("lsp_signature").setup({
        noice = true,
        hint_enable = false,
        hint_prefix = "󱙇 ",
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        floating_window = false,
        handler_opts = {
            border = U.default_border, -- double, rounded, single, shadow, none, or a table of borders
        },
        bind = false,         -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
    })
end

return M
