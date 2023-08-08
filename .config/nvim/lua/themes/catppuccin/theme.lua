local flavour = "macchiato"

require("catppuccin").setup({
    flavour = flavour,       -- latte, frappe, macchiato, mocha
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.65,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { "italic" },
        operators = {},
    },
    color_overrides = {
        all = {
            -- base = "#16161D",
        },
    },
    highlight_overrides = {
        all = function(colors)
            return {
                Visual = { bg = "#234370" },
                -- Visual = { bg = colors.blue, fg = colors.crust },
                LineNr = {
                    fg = colors.surface2,
                },
                CursorLineNr = {
                    fg = colors.peach,
                },
                NormalFloat = {
                    bg = colors.base,
                    fg = colors.text,
                },
                NoiceCmdlinePopupBorder = {
                    link = "NormalFloat",
                },

                NoiceFormatLevelOff = {
                    bg = colors.yellow,
                },
                FloatBorder = {
                    bg = colors.base,
                    fg = colors.surface1,
                },
                FloatTitle = {
                    fg = colors.text,
                },
                PopupBorder = {
                    link = "FloatBorder",
                },
                PopupNormal = {
                    bg = colors.base,
                    fg = colors.text,
                },
                Pmenu = {
                    link = "FloatBorder",
                },
                PmenuBorder = {
                    link = "FloatBorder",
                },
                PmenuDocBorder = {
                    link = "FloatBorder",
                },
                PmenuSel = {
                    -- link = "Visual",
                    bg = colors.surface0,
                },
                NeoTreeNormal = {
                    bg = colors.base,
                },
                IlluminatedWordRead = {
                    bold = true,
                    bg = colors.surface0,
                },
                IlluminatedWordWrite = {
                    bold = true,
                    bg = colors.surface0,
                },
                IluminatedReferenceText = {
                    bold = true,
                    bg = colors.surface0,
                },
                CmpItemAbbrMatch = {
                    fg = colors.blue,
                },
                CmpItemAbbrMatchFuzzy = {
                    fg = colors.sapphire,
                },
                TelescopeSelection = {
                    link = "PmenuSel",
                },
                FlashLabel = {
                    fg = "#000000",
                    bg = "#FFFF00",
                    bold = true,
                },
                NeoTreeIndentMarker = {
                    fg = colors.surface0,
                },
                NoicePopupmenu = {
                    link = "PopupNormal",
                },
                NoicePopupmenuBorder = {
                    link = "FloatBorder",
                },
            }
        end,
    },
    integrations = {
        cmp = true,
        bufferline = false,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = false,
        harpoon = true,
        dap = true,
        lsp_trouble = true,
        mason = true,
        barbar = true,
        telekasten = true,
        leap = true,
        noice = true,
        lsp_saga = false,
        illuminate = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

--require('catppuccin').load()
vim.cmd.colorscheme("catppuccin")
local colors = require("catppuccin.palettes").get_palette("mocha")

local TelescopeColor = {
    TelescopeMatching = { link = "CmpItemAbbrMatch" },

    -- TelescopePromptPrefix = { bg = colors.surface0 },
    -- TelescopePromptNormal = { bg = colors.surface0 },
    -- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.base },

    TelescopeResultsNormal = { fg = colors.subtext0 },
    -- TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopeResultsTitle = { bg = colors.blue, fg = colors.base },

    -- TelescopePreviewBorder = { bg = colors.base, fg = colors.base },
    TelescopePreviewNormal = {},
    TelescopePreviewTitle = { bg = colors.green, fg = colors.base },

    -- TelescopeBorder = { fg = colors.base },
}

for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
end

vim.api.nvim_set_hl(0, "@variable", { fg = colors.text })
vim.api.nvim_set_hl(0, "@field", { fg = colors.red })
