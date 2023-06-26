local M = {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
}

function M.config()
    vim.g.code_action_menu_window_border = "rounded"
end

return M
