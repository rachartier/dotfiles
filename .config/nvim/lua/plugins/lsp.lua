local M = {

    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
        'onsails/lspkind.nvim',

        -- LSP Support
        'neovim/nvim-lspconfig',

        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    }
}

function M.config()
    local lsp = require("lsp-zero")
    local u = require("utils")

    lsp.preset("recommended")

    local on_attach = function(client, bufnr)
        local bufopts = {buffer = bufnr, remap = false}
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover,bufopts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol,bufopts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float,bufopts, {desc = "Open diagnostic inside a floating window."})
        vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next,bufopts, {desc = "Go to next diagnostic"})
        vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev,bufopts, {desc = "Go to previous diagnostic"})
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,bufopts)
        vim.keymap.set("n", "<leader>ca", "<cmd>CodeActionMenu<cr>",bufopts, {desc = "Open code action menu"})
        vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references,bufopts, {desc = "Find references"})
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,bufopts, {desc = "Rename"})
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help,bufopts, {desc = "Help"})

        require 'illuminate'.on_attach(client)
    end

    vim.cmd([[
    sign define DiagnosticSignError text= texthl= linehl= numhl=DiagnosticSignError
    sign define DiagnosticSignWarn  text= texthl= linehl= numhl=DiagnosticSignWarn
    sign define DiagnosticSignInfo  text= texthl= linehl= numhl=DiagnosticSignInfo
    sign define DiagnosticSignHint  text=󱤅 texthl= linehl= numhl=DiagnosticSignHint
    ]])

    local util = require 'lspconfig/util'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local path = util.path

    local function get_python_path(workspace)
        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
            return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
        end

        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({'*', '.*'}) do
            local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
            if match ~= '' then
                return path.join(path.dirname(match), 'bin', 'python')
            end
        end

        -- Fallback to system Python.
        return exepath('python3') or exepath('python') or 'python'
    end


    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require('lspconfig')['pyright'].setup {
        before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern('pyrightconfig.json')
    }

    require('lspconfig')['clangd'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    require('lspconfig')['bashls'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    require('lspconfig')['jsonls'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    require('lspconfig')['vimls'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    require('lspconfig')['lua_ls'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = u.border_chars_outer_thin,
    })
end

return M
