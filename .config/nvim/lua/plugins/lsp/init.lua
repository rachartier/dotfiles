local M = {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {

        "onsails/lspkind.nvim",

        "neovim/nvim-lspconfig",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
    },
    -- event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "LspInfo", "LspInstall", "LspUninstall" },
}

function M.config()
    local lsp = require("lsp-zero")

    local U = require("utils")

    local on_attach = require("config.lsp.attach").on_attach

    lsp.preset("recommended")

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.diagnostic.config({
        float = { border = U.default_border },
        virtual_lines = { highlight_whole_line = false, only_current_line = true },
        virtual_text = {
            prefix = "●",
        },
    })

    local util = require("lspconfig/util")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local path = util.path

    local function get_python_path(workspace)
        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
            return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        end

        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({ "*", ".*" }) do
            local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
            if match ~= "" then
                return path.join(path.dirname(match), "bin", "python")
            end
        end

        -- Fallback to system Python.
        return vim.fn.executable("python3") == 1 or vim.fn.executable("python") == 1 or "python"
    end

    require("lspconfig.ui.windows").default_options = {
        border = U.default_border,
    }

    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require("lspconfig")["pyright"].setup({
        before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern("pyrightconfig.json"),
        settings = {
            pyright = {
                autoImportCompletion = true,
            },
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
    })

    require("lspconfig")["clangd"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
        },
    })

    require("lspconfig")["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                hint = {
                    enabled = true,
                },
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    })

    -- require("lspconfig")["csharp_ls"].setup({
    --     capabilities = capabilities,
    --     on_attach = on_attach,
    -- })

    require("lspconfig")["omnisharp"].setup({
        handlers = {
            ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
        capabilities = capabilities,
        on_attach = on_attach,
        --cmd = { "dotnet", os.getenv("HOME") .. "/.local/omnisharp/run/OmniSharp.dll" },
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = false,
        enable_roslyn_analyzers = false,
        organize_imports_on_format = true,
        enable_import_completion = true,
        sdk_include_prereleases = true,
        analyze_open_documents_only = false,
    })

    local lsp_configurations = require("lspconfig.configs")

    if not lsp_configurations.pico8lsp then
        lsp_configurations.pico8lsp = {
            default_config = {
                cmd = { "pico8-ls", "--stdio" },
                name = "pico8-ls",
                filetypes = { "pico8" },
                root_dir = util.root_pattern("*.p8"),
            },
        }
    end
end

return M
