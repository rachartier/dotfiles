local M = {
    "folke/trouble.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    }
}
function M.config()
    require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        use_diagnostic_signs = false,
        auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
    }

    vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { silent = true })
    vim.keymap.set("n", "<leader>tn", function() require("trouble").next({skip_groups = true, jump = true}) end, { silent = true })
    vim.keymap.set("n", "<leader>tp", function() require("trouble").previous({skip_groups = true, jump = true}) end, { silent = true })
end

return M
