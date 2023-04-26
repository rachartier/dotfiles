require('onedark').setup {
    style = 'dark',
    term_colors = true, -- Change terminal color as per the selected theme style
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}

require('onedark').load()

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
