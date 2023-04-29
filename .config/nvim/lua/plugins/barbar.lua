local M = {
    'romgrk/barbar.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
}

function M.config()
    vim.g.barbar_auto_setup = false

    require'barbar'.setup {
        animation = true,

        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = false,

        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,

        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,
    }
end

return M
