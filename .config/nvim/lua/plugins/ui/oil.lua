local M = {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = false,
}

function M.config()
    require("oil").setup({
        keymaps = {
            ["<BS>"] = "actions.parent",
        },
    })
    vim.keymap.set("n", "<leader>te", function()
        require("oil").open_float()
    end, { desc = "Open parent directory" })
end

return M
