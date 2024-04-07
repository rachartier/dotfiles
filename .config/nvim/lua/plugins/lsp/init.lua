local M = {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "onsails/lspkind.nvim",
        "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
}

function M.config()
    local lsp = require("lsp-zero")

    local U = require("utils")
    local icons = require("config.icons")
    local on_attach = require("config.lsp.attach").on_attach

    lsp.preset("recommended")
    -- require("clangd_extensions.inlay_hints").setup_autocmd()

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf

            on_attach(client, bufnr)
        end,
    })

    require("lspconfig.ui.windows").default_options = {
        border = icons.default_border,
    }

    local config = require("config")

    for server_name, defined_lsp in pairs(config.lsp) do
        if type(defined_lsp) == "table" then
            defined_lsp.capabilities = capabilities

            require("lspconfig")[server_name].setup(defined_lsp)
        end
    end
end

function M.opts() end

return M
