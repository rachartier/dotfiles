require('sweetie').setup({
    pumblend = {
        enable = true,
        transparency_amount = 20,
    },
    palette = {
        dark = {
            bg_alt = "#484863"
        },
        light = {},
    },
    integrations = {
        lazy = true,
        neorg = true,
        neogit = true,
        telescope = true,
    },
    cursor_color = true,
    terminal_colors = true,
})

vim.cmd.colorscheme('sweetie')

local colors = require("sweetie.colors").palette.dark
local TelescopeColor = {
    TelescopeMatching = { fg = colors.blue},
    TelescopeSelection = { fg = colors.blue , bg = colors.bg, bold = true },

    TelescopePromptPrefix = { bg = colors.bg_hl},
    TelescopePromptNormal = { bg = colors.bg_hl},
    TelescopeResultsNormal = { bg = colors.bg_alt},
    TelescopePreviewNormal = { bg = colors.bg_alt},
    TelescopePromptBorder = { bg = colors.bg_hl, fg = colors.bg_hl},
    TelescopeResultsBorder = { bg = colors.bg_alt, fg = colors.bg_alt},
    TelescopePreviewBorder = { bg = colors.bg_alt, fg = colors.bg_alt},
    TelescopePromptTitle = { bg = colors.magenta, fg = colors.bg_alt},
    TelescopeResultsTitle = { fg = colors.bg_alt },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.bg_alt },
}

for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
end

--IlluminateColor = {bg = colors.dark_grey,}

--vim.api.nvim_set_hl(0, "LspReferenceText", IlluminateColor)
--vim.api.nvim_set_hl(0, "LspReferenceWrite", IlluminateColor)
--vim.api.nvim_set_hl(0, "LspReferenceRead", IlluminateColor)
--vim.api.nvim_set_hl(0, "illuminatedCurWord", IlluminateColor)
--vim.api.nvim_set_hl(0, "IlluminatedWordText", IlluminateColor)
--vim.api.nvim_set_hl(0, "IlluminatedWordWrite", IlluminateColor)
--vim.api.nvim_set_hl(0, "IlluminatedWordRead", IlluminateColor)
vim.api.nvim_set_hl(0, "Cursor", { bg = colors.fg_alt})
vim.api.nvim_set_hl(0, "Visual", { bg = "#69698E"})
