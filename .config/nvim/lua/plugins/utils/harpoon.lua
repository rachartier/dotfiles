local M = {
    "ThePrimeagen/harpoon",
    enabled = false,
}

function M.config()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    require("telescope").load_extension("harpoon")
    require("harpoon").setup({})

    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add mark" })
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon show marks" })
end

return M
