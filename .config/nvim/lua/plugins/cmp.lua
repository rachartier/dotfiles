local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
    },
    event = "InsertEnter",
}

function M.config()
    local cmp = require("cmp")
    local U = require("utils")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.cmd("set completeopt=menu,menuone,noselect")

    local has_words_before = function()
        if not table.unpack then
            table.unpack = unpack
        end
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local function format(_, item)
        local MAX_LABEL_WIDTH = 50
        local function whitespace(max, len)
            return (" "):rep(max - len)
        end

        local content = item.abbr
        if #content > MAX_LABEL_WIDTH then
            item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. "…"
        else
            item.abbr = content .. whitespace(MAX_LABEL_WIDTH, #content)
        end

        item.kind = " " .. (U.kind_icons[item.kind] or U.kind_icons.Unknown) .. "│"
        item.menu = nil

        return item
    end

    local filter_text = function(entry, _)
        local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
        return kind ~= "Text"
    end

    local mapping_selection_down = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s", "c" })

    local mapping_selection_up = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s", "c" })

    ---@diagnostic disable-next-line: redundant-parameter
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp",     entry_filter = filter_text },
            { name = "buffer",       entry_filter = filter_text },
            { name = "luasnip",      entry_filter = filter_text },
            { name = "latex_symbols" },
        }),
        mapping = cmp.mapping.preset.insert({
            ["<C-BS>"] = {
                i = cmp.config.disable,
            },
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = mapping_selection_down,
            ["<S-Tab>"] = mapping_selection_up,

            ["<Up>"] = mapping_selection_up,
            ["<Down>"] = mapping_selection_down,
        }),

        formatting = {
            fields = { "kind", "abbr" },
            format = format,
        },

        window = {
            completion = cmp.config.window.bordered({
                winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
                scrollbar = true,
                border = U.default_border,
                col_offset = -1,
                side_padding = 0,
            }),
            documentation = cmp.config.window.bordered({
                winhighlight = "NormalFloat:NormalFloat,FloatBorder:PmenuBorder",
                scrollbar = true,
                border = U.default_border,
                side_padding = 1, -- Not working?
            }),
        },
    })

    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "cmp_git" },
        }, {
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })

    cmp.setup.buffer({
        sources = {
            { name = "nvim_lsp" },
            { name = "latex_symbols" },
        },
    })
end

return M
