local M = {
    "jose-elias-alvarez/null-ls.nvim",
}

local with_diagnostics_code = function(builtin)
    return builtin.with({
        diagnostics_format = "#{m} [#{c}]",
    })
end

local with_root_file = function(builtin, file)
    return builtin.with({
        condition = function(utils)
            return utils.root_has_file(file)
        end,
    })
end

function M.config()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end,
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.completion.spell,
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.formatting.fixjson,
            null_ls.builtins.formatting.black.with({ extraArgs = "--line-length=400" }),
            null_ls.builtins.formatting.ruff,
            null_ls.builtins.formatting.isort,

            -- code actions
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.code_actions.gitrebase,
            null_ls.builtins.code_actions.proselint,
            null_ls.builtins.code_actions.refactoring,

            -- hover
            null_ls.builtins.hover.dictionary,
        },
    })
end

return M
