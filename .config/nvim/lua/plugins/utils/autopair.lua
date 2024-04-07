local M = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
}

function M.config()
    require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel", "copilot-chat" }
    })
end

return M
