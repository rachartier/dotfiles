local M = {}

M.border = {
    round = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    none = { "", "", "", "", "", "", "", "" },
    empty = { " ", " ", " ", " ", " ", " ", " ", " " },
    inner_thick = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" },
    outer_thick = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" },
    cmp_items = { "▛", "▀", "▀", " ", "▄", "▄", "▙", "▌" },
    cmp_doc = { "▀", "▀", "▀", " ", "▄", "▄", "▄", "▏" },
    outer_thin = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
    inner_thin = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" },
    outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
    outer_thick_telescope = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
}

M.default_border = M.border.empty

M.signs = {
    file = {
        modified = "󱞁 ",
        not_saved = "󰉉 ",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
        -- added = " ",
        -- modified = " ",
        -- removed = " ",
    },
    diagnostic = {
        error = "●",
        warning = "●",
        warn = "●",
        info = "●",
        hint = "●",
        other = "●",
        -- error = " ",
        -- warning = " ",
        -- warn = " ",
        -- info = " ",
        -- hint = " ",
        -- other = "󰠠 ",
    },
}

-- M.diagnostic_signs = {
-- 	error = "●",
-- 	warning = "●",
-- 	info = "●",
-- 	hint = "●",
-- 	other = "●",
-- }

-- M.diagnostic_signs = {
--     error = " ",
--     warning = " ",
--     info = " ",
--     hint = "󱤅 ",
--     other = "󰠠 ",
-- }

M.kind_icons = {
    Text = " ",
    Method = " ",
    Function = "󰊕 ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Class = " ",
    Interface = " ",
    Module = "󰏓 ",
    Property = " ",
    Unit = " ",
    Value = "󰎠 ",
    Enum = " ",
    EnumMember = " ",
    Keyword = "󰌋 ",
    Snippet = " ",
    Color = " ",
    File = "󰈙 ",
    Reference = "󰈇 ",
    Folder = " ",
    Constant = "󰏿 ",
    Struct = "󰙅 ",
    Event = " ",
    Operator = " ",
    TypeParameter = "󰘦 ",
    Codeium = " ",
    Version = " ",
    Unknown = "  ",
}

return M
