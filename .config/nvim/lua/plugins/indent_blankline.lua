local M = {
    "lukas-reineke/indent-blankline.nvim",
}

function M.config()
    require("indent_blankline").setup({
        char = "",
        show_current_context = true,
        show_current_context_start = false,
        space_char_blankline = " ",
    })
end

return M
