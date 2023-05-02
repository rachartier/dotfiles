local M = {
    'windwp/nvim-spectre'
}

function M.config()
    require('spectre').setup()

    vim.keymap.set("n", "<leader>S", "<cmd>lua require('spectre').open()<CR>", {desc="Open Spectre to search & replace across all project"})
    vim.keymap.set("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", {desc="Open Spectre to search & replace the under the cursors word"})

    vim.keymap.set("n", "<leader>s", "<esc>:lua require('spectre').open_visual()<CR>", {desc="Open the vim command line way for search & replace"})
    vim.keymap.set("n", "<leader>sp", "viw:lua require('spectre').open_file_search()<cr>", {desc="Search inside the file"})
end

return M
