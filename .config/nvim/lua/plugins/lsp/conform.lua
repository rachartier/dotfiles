local linters = require("config.linter").enabled
local formatters = require("config.formatter").enabled
local extras = require("config").extras

-- PENDING https://github.com/mfussenegger/nvim-lint/issues/355
-- for _, list in pairs(linters.enabled) do
--     table.insert(list, "typos")
--     table.insert(list, "editorconfig-checker")
-- end

local dont_install = {
    -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
    "stylelint",
    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
    "injected",
}

local function to_autoinstall(myLinters, myFormatters, extras, ignoreTools)
    -- get all linters, formatters, & debuggers and merge them into one list
    local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
    local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
    local tools = vim.list_extend(linterList, formatterList)
    vim.list_extend(tools, extras)

    -- only unique tools
    table.sort(tools)
    tools = vim.fn.uniq(tools)

    -- remove exceptions not to install
    tools = vim.tbl_filter(function(tool)
        return not vim.tbl_contains(ignoreTools, tool)
    end, tools)
    return tools
end

local function lint_triggers()
    local function do_lint()
        vim.defer_fn(function()
            if vim.bo.buftype ~= "" then
                return
            end

            -- GUARD only when in lua, only lint when selene file available
            -- https://github.com/mfussenegger/nvim-lint/issues/370#issuecomment-1729671151
            if vim.bo.ft == "lua" then
                local noSeleneConfig = vim.loop.fs_stat((vim.loop.cwd() or "") .. "/selene.toml") == nil
                if noSeleneConfig then
                    local luaLinters = require("lint").linters_by_ft.lua
                    local noSelene = vim.tbl_filter(function(linter)
                        return linter ~= "selene"
                    end, luaLinters)
                    require("lint").try_lint(noSelene)
                    return
                end
            end

            require("lint").try_lint()
        end, 1)
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
        callback = do_lint,
    })

    -- due to auto-save.nvim, we need the custom event "AutoSaveWritePost"
    -- instead of "BufWritePost" to trigger linting to prevent race conditions
    vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePost",
        callback = do_lint,
    })

    do_lint() -- run once on initialization
end

return {
    { -- Linter integration
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = linters
            for name, value in pairs(require("config.linter").by_ft_options) do
                lint.linters[name].args = value.args
            end

            lint_triggers()
        end,
    },
    { -- Formatter integration
        "stevearc/conform.nvim",
        enabled = true,
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function()
            require("conform").setup({
                formatters_by_ft = formatters,
                format_on_save = function(bufnr)
                    local bufnr = vim.api.nvim_get_current_buf()
                    local errors = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.ERROR } })

                    if #errors > 0 then
                        return
                    end

                    return {
                        quiet = true,
                        timeout_ms = 500,
                        lsp_fallback = true,
                    }
                end,
            })

            require("conform").formatters = require("config.formatter").by_ft_options
        end,

        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<D-s>",
                function()
                    require("conform").format({ lsp_fallback = "always" })
                    vim.cmd.update()
                end,
                mode = { "n", "x" },
                desc = "󰒕 Format & Save",
            },
        },
    },
    { -- auto-install missing linters & formatters
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>pM", vim.cmd.MasonToolsUpdate, desc = " Mason Update" },
        },
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        config = function()
            local tools = to_autoinstall(linters, formatters, extras, dont_install)
            -- vim.list_extend(tools, require("config").lsp)

            require("mason-tool-installer").setup({
                ensure_installed = tools,
                run_on_start = false, -- triggered manually, since not working with lazy-loading
            })

            -- clean unused & install missing
            vim.defer_fn(vim.cmd.MasonToolsInstall, 500)
            -- vim.defer_fn(vim.cmd.MasonToolsClean, 1000) -- delayed, so noice.nvim is loaded before
        end,
    },
}
