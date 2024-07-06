return {
    {
        -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_buffers_switcher.nvim",
        "rachartier/tiny-buffers-switcher.nvim",
        event = "LazyFile",
        keys = {
            {
                "<Tab>",
                function()
                    require("tiny-buffers-switcher").switcher()
                end,
                { noremap = true, silent = true },
            },
            {
                "<S-Tab>",
                function()
                    require("tiny-buffers-switcher").switcher()
                end,
                { noremap = true, silent = true },
            },
        },
        config = function()
            require("tiny-buffers-switcher").setup({
                --				use_fzf_lua = true,
            })
        end,
    },
    {
        -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny_interpo_string.nvim",
        "rachartier/tiny-interpo-string.nvim",
        ft = { "python", "cs" },
        config = function()
            require("tiny_interpo_string").setup()
        end,
    },
    {
        -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-inline-diagnostic.nvim",
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup({
                hi = {
                    -- background = "None",
                    mixing_color = require("theme").get_colors().base,
                },
                blend = {
                    factor = 0.15,
                }
            })
        end,
    },
    {
        -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/tiny-devicons-auto-colors.nvim",
        "rachartier/tiny-devicons-auto-colors.nvim",
        branch = "main",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        enabled = true,
        config = function()
            local colors = require("theme").get_colors()
            -- local colors = require("tokyonight.colors").setup()
            require("tiny-devicons-auto-colors").setup({
                colors = colors,
                -- autoreload = true,
                cache = { enabled = true },
            })
        end,
    },
}
