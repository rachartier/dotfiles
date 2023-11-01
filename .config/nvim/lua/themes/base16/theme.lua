local M = {}

function M.get_colors()
    local base16_colors = require("base16-colorscheme").colors

    local colors = {
        surface0 = base16_colors.base02,
        surface2 = base16_colors.base04,
        overlay1 = base16_colors.base03,
        overlay2 = base16_colors.base05,
        mantle = base16_colors.base01,
        crust = base16_colors.base00,
        pink = base16_colors.base0E,
        green = base16_colors.base0B,
        red = base16_colors.base08,
        yellow = base16_colors.base0A,
        blue = base16_colors.base0D,
        flamingo = base16_colors.base0F,
        text = base16_colors.base07,
        peach = base16_colors.base0F,
        base = base16_colors.base00,
        subtext1 = base16_colors.base06,
        subtext0 = base16_colors.base06,
        orange = base16_colors.base09,
    }
end

function M.setup()
    require("base16-colorscheme").with_config({
        telescope = true,
        telescope_borders = true,
        indentblankline = true,
        notify = true,
        ts_rainbow = true,
        cmp = true,
        illuminate = true,
        lsp_semantic = true,
        mini_completion = true,
    })

    vim.cmd("colorscheme base16-catppuccin-macchiato")

    require("themes.groups").override_hl(M.get_colors())
    require("themes.groups").override_lsp_hl(M.get_colors())
end

return M
