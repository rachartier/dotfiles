local M = {
    "dbeniamine/cheat.sh-vim",
}

function M.config()
    vim.g.CheatSheetDefaultMode = 3
    vim.g.CheatSheetShowCommentsByDefault = 0
end

return M
