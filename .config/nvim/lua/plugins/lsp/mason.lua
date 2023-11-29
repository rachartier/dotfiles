local M = {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    build = ":MasonUpdate",
}

function M.config()
    local U = require("utils")

    require("mason").setup({ ui = { border = U.default_border } })

    local lsp = require("lsp-zero")
    lsp.extend_lspconfig()

    require("mason-lspconfig").setup({
        ensure_installed = require("config").lsps,
    })
    -- require("mason-null-ls").setup({
    -- 	ensure_installed = {
    -- 		"black",
    -- 		"flake8",
    -- 		"shellcheck",
    -- 		"autoflake",
    -- 		"autopep8",
    -- 		"ruff",
    -- 	},
    -- 	automatic_installation = true,
    -- 	automatic_setup = true,
    -- })
    --
    -- local lspconfig = require("lspconfig")
    -- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- local on_attach = require("config.lsp.attach").on_attach

    -- require("mason-lspconfig").setup_handlers({
    -- 	function(server_name)
    -- 		lspconfig[server_name].setup({
    -- 			capabilities = lsp_capabilities,
    -- 			on_attach = on_attach,
    -- 		})
    -- 	end,
    -- })
end

return M
