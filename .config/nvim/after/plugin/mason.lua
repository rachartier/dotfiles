require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "dockerls", "jsonls", "bashls", "pyright" }
})
