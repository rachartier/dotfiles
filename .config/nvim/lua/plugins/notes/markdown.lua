return {
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        config = function()
            require("glow").setup({
                border = "rounded",
            })
        end,
    },
    {
        "richardbizik/nvim-toc",
        ft = "markdown",
        config = function()
            require("nvim-toc").setup({})
        end,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = "markdown",
        config = function()
            vim.g.table_mode_corner = "|"
        end,
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = {
            "markdown",
            "neorg",
        },
        config = function()
            require("headlines").setup({
                markdown = {
                    fat_headline_lower_string = "▀",
                },
            })
        end,
    },
}
