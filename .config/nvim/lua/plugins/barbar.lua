local M = {
    "romgrk/barbar.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    enabled = false,
}

function M.config()
    vim.g.barbar_auto_setup = false

    require("barbar").setup({
        animation = true,

        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = false,

        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,

        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,
    })

    -- vim.keymap.set("n", "<Tab>", "<cmd>BufferNext<cr>", { silent = true })
    -- vim.keymap.set("n", "<S-Tab>", "<cmd>BufferPrevious<cr>", { silent = true })
end

return M
