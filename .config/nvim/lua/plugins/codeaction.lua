local M = {
    "weilbith/nvim-code-action-menu",
    enabled = false,
}

function M.config()
    vim.g.code_action_menu_window_border = "rounded"
    vim.g.code_action_menu_show_action_kind = true
end

return M
