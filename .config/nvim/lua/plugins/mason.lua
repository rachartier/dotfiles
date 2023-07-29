local M = {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
    },

    event = { "BufReadPost", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUninsllAll", "MasonUninsll" },
}

function M.config()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "dockerls", "jsonls", "bashls", "pyright" },
    })
    require("mason-null-ls").setup({
        ensure_installed = {
            "black",
            "flake8",
            "shellcheck",
            "autoflake",
            "autopep8",
            "ruff",
        },
        automatic_installation = true,
        automatic_setup = true,
    })
end

return M
