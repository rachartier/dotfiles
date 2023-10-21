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
    })
end

return M
