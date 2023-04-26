local flavour = "frappe"

require("catppuccin").setup({
    flavour = flavour, -- latte, frappe, macchiato, mocha
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.01,
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
    },
    highlight_overrides = {
        all = function(colors)
            return {
                LineNr = { fg = colors.overlay0 },
                NormalFloat = {
                    bg = colors.crust,
                },
                PopupNormal = {
                    bg = colors.crust,
                    fg = colors.overlay1,
                },
                PopupBorder = {
                    bg = colors.crust,
                    fg = colors.subtext1
                },
                Pmenu = {
                    link = 'PopupNormal',
                },
                PmenuSel = {
                    bg = colors.crust,
                    fg = colors.text,
                    bold = true
                },
                PmenuBorder = {
                    link = 'PopupBorder'
                },
                PmenuDocBorder = {
                    bg = colors.crust,
                    fg = colors.text
                },
                NvimTreeNormal = {
                    bg = colors.crust,
                },
                FloatBorder = {
                    bg = colors.crust,
                },
                TerminalBorder = {
                    bg = colors.surface0,
                },
                TerminalNormal = {
                    bg = colors.surface0,
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
        lsp_saga = true,
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

local colors = require("catppuccin.palettes").get_palette("macchiato")

--require('catppuccin').load()
vim.cmd.colorscheme "catppuccin"

local TelescopeColor = {
    TelescopeMatching = { fg = colors.flamingo },
    TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

    TelescopePromptPrefix = { bg = colors.surface0 },
    TelescopePromptNormal = { bg = colors.surface0 },
    TelescopeResultsNormal = { bg = colors.mantle },
    TelescopePreviewNormal = { bg = colors.mantle },
    TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
    TelescopeResultsTitle = { fg = colors.mantle },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
}

for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
end


--vim.api.nvim_set_hl(0, "NormalFloat", {bg="None"})
