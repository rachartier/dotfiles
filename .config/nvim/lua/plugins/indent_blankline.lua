local M = {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {

        "echasnovski/mini.indentscope",
    },
}

function M.config()
    require("indent_blankline").setup({
        -- char = "|",
        show_current_context = false,
        show_current_context_start = false,
        show_trailing_blankline_indent = true,
        -- space_char_blankline = " ",
        max_indent_increase = 1,
    })
    vim.g.indent_blankline_use_treesitter = false
    vim.g.indent_blankline_show_trailing_blankline_indent = false

    require("mini.indentscope").setup({
        draw = {
            delay = 0,
            animation = require("mini.indentscope").gen_animation.none(),
        },
        options = {
            indent_at_cursor = true,
        },
        symbol = "│",
    })
end

return M
