local M = {
    'mbbill/undotree'
}

function M.config()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {desc = "Open UndoTree"})
    vim.g.undotree_WindowLayout = 2
end

return M
