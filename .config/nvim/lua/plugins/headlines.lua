local M = {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = {
        "markdown",
        "neorg",
    },
}

function M.config()
    require("headlines").setup({
        markdown = {
            fat_headline_lower_string = "▀",
        },
    })
end

return M
