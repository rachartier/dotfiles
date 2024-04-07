local M = {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim"
    },
    keys = {
        { "<leader>fn", "<cmd>Navbuddy<cr>", desc = "Open NavBuddy" },
    },
}

function M.config()
    require("nvim-navbuddy").setup({
        lsp = {
            auto_attach = true, -- If set to true, you don't need to manually use attach function
        },
        node_markers = {
            enabled = true,
            icons = {
                leaf = "  ",
                leaf_selected = " → ",
                branch = "  ",
            },
        },
    })
end

return M
