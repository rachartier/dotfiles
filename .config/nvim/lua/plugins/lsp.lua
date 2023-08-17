local M = {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "onsails/lspkind.nvim",

        -- LSP Support
        "neovim/nvim-lspconfig",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
}

function M.config()
    local lsp = require("lsp-zero")
    local U = require("utils")

    local function lsp_rename()
        local curr_name = vim.fn.expand("<cword>")
        local value = vim.fn.input("LSP Rename: ", curr_name)
        local lsp_params = vim.lsp.util.make_position_params()

        if not value or #value == 0 or curr_name == value then
            return
        end

        -- request lsp rename
        lsp_params.newName = value
        vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
            if not res then
                return
            end

            -- apply renames
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

            -- print renames
            local changed_files_count = 0
            local changed_instances_count = 0

            if res.documentChanges then
                for _, changed_file in pairs(res.documentChanges) do
                    changed_files_count = changed_files_count + 1
                    changed_instances_count = changed_instances_count + #changed_file.edits
                end
            elseif res.changes then
                for _, changed_file in pairs(res.changes) do
                    changed_instances_count = changed_instances_count + #changed_file
                    changed_files_count = changed_files_count + 1
                end
            end

            -- compose the right print message
            require("notify")(
                string.format(
                    "Renamed %s instance%s in %s file%s.",
                    changed_instances_count,
                    changed_instances_count == 1 and "" or "s",
                    changed_files_count,
                    changed_files_count == 1 and "" or "s"
                )
            )

            vim.cmd("silent! wa")
        end)
    end

    lsp.preset("recommended")

    vim.diagnostic.config({
        float = { border = U.default_border },
    })

    local on_attach = function(client, bufnr)
        -- client.server_capabilities.semanticTokensProvider = nil

        local bufopts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, bufopts)
        vim.keymap.set(
            "n",
            "<leader>vd",
            vim.diagnostic.open_float,
            bufopts,
            { desc = "Open diagnostic inside a floating window." }
        )
        vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, bufopts, { desc = "Go to next diagnostic" })
        vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, bufopts, { desc = "Go to previous diagnostic" })
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,bufopts)
        vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, bufopts, { desc = "Find references" })
        -- vim.keymap.set("n", "<leader>ca", "<cmd>CodeActionMenu<cr>", bufopts, { desc = "Open code action menu" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts, { desc = "Open code action menu" })

        vim.keymap.set("n", "<leader>rn", function()
            lsp_rename()
        end, bufopts, { desc = "Rename current symbol" })

        vim.keymap.set(
            "n",
            "<leader>e",
            "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
            { desc = "Show line diagnostics" }
        )
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, bufopts, { desc = "Help" })
    end

    local util = require("lspconfig/util")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
        return exepath("python3") or exepath("python") or "python"
    end

    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require("lspconfig")["pyright"].setup({
        before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern("pyrightconfig.json"),
    })

    require("lspconfig")["clangd"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    require("lspconfig")["bashls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    require("lspconfig")["jsonls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    require("lspconfig")["vimls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
end

return M
