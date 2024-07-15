return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local icons = require("config.icons")

        require("which-key").setup({
            preset = "modern",
            win = {
                border = icons.default_border,
                padding = { 1, 2, }, -- extra window padding [top, right, bottom, left]
                -- winblend = 0,    -- value between 0-100 0 for fully opaque and 100 for fully transparent
            },
            replace = {
                key = {
                    { "<leader>", "SPC" },
                    { "<space>",  "SPC" },
                    { "<cr>",     "RET" },
                    { "<tab>",    "TAB" }
                }
            },
        })
    end,
}
