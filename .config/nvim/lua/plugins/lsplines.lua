local M = {
    "rachartier/mirror_lsp_lines.nvim",
}

function M.config()
    require("lsp_lines").setup({})
    -- Disable virtual_text since it's redundant due to lsp_lines.
    --
    local virtual_lines_enabled = true
    vim.keymap.set("n", "<leader>l", "", {
        callback = function()
            virtual_lines_enabled = not virtual_lines_enabled

            if virtual_lines_enabled == true then
                vim.diagnostic.config({
                    virtual_lines = { highlight_whole_line = false, only_current_line = true },
                    virtual_text = false,
                })
            else
                vim.diagnostic.config({
                    virtual_lines = false,
                    virtual_text = true,
                })
            end
        end,
    })

    vim.diagnostic.config({
        virtual_lines = { highlight_whole_line = false, only_current_line = true },
        virtual_text = false,
    })
end

return M
