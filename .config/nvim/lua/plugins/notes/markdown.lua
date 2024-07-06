return {
    {
        enabled = true,
        ft = { "markdown" },
        event = "BufReadPre",
        "OXY2DEV/markview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
        },
        branch = "dev",

        config = function()
            require("markview").setup({
                checkbox = {
                    checked = {
                        marker = " 󰄲 ",
                        marker_hl = "@markup.list.checked",
                    },
                    uncheked = {
                        marker = " 󰄱 ",
                        marker_hl = "@markup.list.unchecked",
                    },
                },
            })
        end,
    },
    {
        enabled = false,
        "MeanderingProgrammer/markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        name = "render-markdown",
        ft = { "markdown", "pandoc" },
        cond = require("config").config_type ~= "minimal",
        config = function()
            require("render-markdown").setup({
                bullets = { "", "", "◆", "◇" },
                headings = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
                checkbox = {
                    unchecked = "󰄱 ",
                    checked = "󰄲 ",
                },
                file_types = { "markdown", "pandoc" },
                highlights = {
                    checkbox = {
                        unchecked = "@markup.list.unchecked",
                        checked = "@markdown_check_done",
                    },
                },
            })

            local function toggle_checkbox(char)
                local current_line = vim.api.nvim_get_current_line()

                local _, _, checkbox_state = string.find(current_line, "%[([ " .. char .. string.upper(char) .. "])%]")

                if checkbox_state then
                    local new_state = checkbox_state == " " and char or " "
                    local new_line = string.gsub(current_line, "%[.-%]", "[" .. new_state .. "]")

                    vim.api.nvim_set_current_line(new_line)
                end
            end
            vim.keymap.set("n", "<Leader>x", function()
                toggle_checkbox("x")
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<Leader>X", function()
                toggle_checkbox("o")
            end, { noremap = true, silent = true })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        enabled = true,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = "markdown",
        config = function()
            vim.g.table_mode_corner = "|"
        end,
        enabled = true,
    },
}
