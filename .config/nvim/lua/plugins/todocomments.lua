local M = {
    "folke/todo-comments.nvim",
}

function M.config()
    require("todo-comments").setup({})

    vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Toggle list TODO" })
end

return M
