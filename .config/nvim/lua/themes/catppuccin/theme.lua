local flavour = "macchiato"

require("catppuccin").setup({
    lazy = true,
    flavour = flavour, -- latte, frappe, macchiato, mocha
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.65,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
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
                -- Visual = { bg = "#234370" },
                Visual = { bg = "#5B6076" },
                -- Visual = { bg = colors.blue, fg = colors.crust },
                LineNr = {
                    fg = colors.surface1,
                },
                CursorLineNr = {
                    fg = colors.overlay1,
                },
                CursorLine = { bg = "None" },
                NormalFloat = {
                    bg = "None",
                    fg = colors.text,
                },
                NoiceCmdlinePopupBorder = {
                    link = "NormalFloat",
                },
                NoiceFormatLevelOff = {
                    bg = colors.yellow,
                },
                FloatBorder = {
                    bg = "None",
                    fg = colors.text,
                },
                FloatTitle = {
                    fg = colors.text,
                },
                PopupBorder = {
                    link = "FloatBorder",
                },
                PopupNormal = {
                    bg = "None",
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
                    bg = "None",
                },
                IlluminatedWordRead = {
                    bold = true,
                    bg = colors.surface1,
                },
                IlluminatedWordWrite = {
                    link = "IlluminatedWordRead",
                },
                IluminatedReferenceText = {
                    link = "IlluminatedWordRead",
                },
                CmpItemAbbrMatch = {
                    fg = colors.red,
                    -- underline = true,
                },
                CmpItemAbbrMatchFuzzy = {
                    fg = colors.red,
                    -- underline = true,
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
                NeoTreeCursorLine = {
                    link = "PmenuSel",
                },
                NoicePopupmenu = {
                    link = "PopupNormal",
                },
                NoicePopupmenuBorder = {
                    link = "FloatBorder",
                },
                MiniIndentscopeSymbol = {
                    fg = colors.surface0,
                },
                LspSignatureActiveParameter = {
                    bg = colors.peach,
                    fg = colors.crust,
                },
                GitSignsChange = {
                    fg = colors.blue,
                },
                GitSignsAdd = {
                    fg = colors.green,
                },
                CmpGhostText = { link = "Comment", default = true },
                -- StatusLine = {
                --     bg = colors.mantle,
                -- },
                --
                -- StatusLineNC = {
                --     link = "StatusLine",
                -- },
            }
        end,
    },
    integrations = {
        alpha = true,
        cmp = true,
        dap = true,
        gitsigns = true,
        -- harpoon = true,
        -- illuminate = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        neotree = true,
        noice = true,
        notify = true,
        telekasten = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
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
            inlay_hints = {
                background = true,
            },
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

vim.cmd.colorscheme("catppuccin")

local colors = require("catppuccin.palettes").get_palette(flavour)

local TelescopeColor = {
    TelescopeMatching = { link = "CmpItemAbbrMatch" },

    -- TelescopePromptPrefix = { bg = colors.surface0 },
    -- TelescopePromptNormal = { bg = colors.surface0 },
    -- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.base },

    TelescopeResultsNormal = { fg = colors.subtext1 },
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

vim.api.nvim_set_hl(0, "@parameter", { fg = colors.red, italic = true })
vim.api.nvim_set_hl(0, "@variable", { fg = colors.text, italic = false })
vim.api.nvim_set_hl(0, "@operator", { fg = colors.teal, italic = false })
vim.api.nvim_set_hl(0, "@attribute", { fg = colors.lavender, italic = true })
vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@repeat" })

vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.red })
vim.api.nvim_set_hl(0, "@type.qualifier", { fg = colors.red })
vim.api.nvim_set_hl(0, "@storageclass", { fg = colors.red })
vim.api.nvim_set_hl(0, "@field", { fg = colors.red })

vim.api.nvim_set_hl(0, "@property", { fg = colors.text })
vim.api.nvim_set_hl(0, "@field", { fg = colors.text })

vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })

-- vim.api.nvim_set_hl(0, "@variable", { fg = colors.text })
vim.api.nvim_set_hl(0, "@_parent", { fg = colors.peach })
