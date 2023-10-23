local M = {
    "mrjones2014/legendary.nvim",

    keys = {
        { "<C-p>", "<cmd>Legendary<cr>", desc = "Open Legendary" },
    },
}

function M.config()
    require("legendary").setup({
        extensions = {
            lazy_nvim = { auto_register = true },
            which_key = { auto_register = false },
        },
        icons = {
            -- keymap items list the modes in which the keymap applies
            -- by default, you can show an icon instead by setting this to
            -- a non-nil icon
            keymap = nil,
            command = " ",
            fn = "󰊕 ",
            itemgroup = " ",
        },
        col_separator_char = "│",
    })
end

return M
