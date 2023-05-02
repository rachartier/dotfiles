local M = {
    'renerocksai/telekasten.nvim',

    dependencies = {
        'godlygeek/tabular',
        'preservim/vim-markdown'
    },
}

function M.config()
    require('telekasten').setup({
        home = vim.fn.expand("~/notes"),
    })

    -- Launch panel if nothing is typed after <leader>z
    vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>", {desc = "Show Telekasten panel"})

    -- Most used functions
    vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "Find notes" })
    vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "Search notes"})
    vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "Go to today"})
    vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>", { desc = "Follow link"})
    vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "New note"})
    vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", { desc = "Show backlinks"})
    vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", { desc = "Insert image link"})
    vim.keymap.set("n", "<leader>zr", "<cmd>Telekasten rename_note()<CR>", { desc = "Rename note"})
    vim.keymap.set("n", "<leader>zp", "<cmd>Telekasten preview_img()<CR>", { desc = "Preview image"})
    vim.keymap.set("n", "<leader>zm", "<cmd>Telekasten browse_media()<CR>", { desc = "Browse media"})
    vim.keymap.set("n", "<leader>za", "<cmd>Telekasten show_tags()<CR>", { desc = "Show tags"})
    vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten toggle_todo({ i=true })<CR>", { desc = "Toggle todo"})

    -- Call insert link automatically when we start typing a link

    vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "markdown",
        callback = function()
            vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
        end
    }
    )

    vim.g.vim_markdown_folding_disabled = 1
end

return M
