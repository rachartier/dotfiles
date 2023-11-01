local M = {}

function M.get_colors()
    local colors = require("nano-theme.colors").get()

    require("utils").add_missing(colors, {
        blue = "#42A5F5",
        cyan = "#26C6DA",
        green = "#66BB6A",
        magenta = "#AB47BC",
        red = "#EF5350",
        yellow = "#E2C12F",
        base0 = "#191C25",
        base1 = "#242832",
        base2 = "#2C333F",
        base3 = "#373E4C",
        base4 = "#434C5E",
        base5 = "#4C566A",
        base6 = "#9099AB",
        base7 = "#D8DEE9",
    })

    -- local nano_foreground_color = is_light_theme and "#37474F" or "#ECEFF4"
    -- local nano_background_color = is_light_theme and "#FFFFFF" or "#2E3440"
    -- local nano_highlight_color  = is_light_theme and "#FAFAFA" or "#3B4252"
    -- local nano_subtle_color     = is_light_theme and "#ECEFF1" or "#434C5E"
    -- local nano_faded_color      = is_light_theme and "#90A4AE" or "#677691"
    -- local nano_salient_color    = is_light_theme and "#673AB7" or "#81A1C1"
    -- local nano_strong_color     = is_light_theme and "#263238" or "#FFFFFF"
    -- local nano_popout_color     = is_light_theme and "#FFAB91" or "#D08770"
    -- local nano_critical_color   = is_light_theme and "#FF6F00" or "#EBCB8B"

    local converted_color_name = {
        blue = colors.blue,
        lavender = colors.nano_highlight_color,
        sapphire = colors.nano_highlight_color,
        sky = colors.nano_highlight_color,
        cyan = colors.nano_highlight_color,
        teal = colors.nano_highlight_color,
        green = colors.green,
        mauve = colors.nano_highlight_color,
        pink = colors.nano_foreground_color,
        flamingo = colors.magenta,
        rosewater = colors.magenta,
        red = colors.red,
        maroon = colors.red,
        peach = colors.nano_highlight_color,
        yellow = colors.yellow,
        base = colors.nano_background_color,
        mantle = colors.base1,
        crust = colors.base0,
        surface0 = colors.nano_highlight_color,
        surface1 = colors.nano_highlight_color,
        surface2 = colors.nano_highlight_color,
        overlay0 = colors.nano_subtle_color,
        overlay1 = colors.nano_subtle_color,
        overlay2 = colors.nano_subtle_color,
        subtext0 = colors.nano_faded_color,
        subtext1 = colors.nano_faded_color,
        text = colors.nano_foreground_color,
    }

    return converted_color_name
end

function M.setup()
    require("nano-theme").load()

    local converted_color_name = M.get_colors()

    require("themes.groups").override_hl(converted_color_name)
    require("themes.groups").override_lsp_hl(converted_color_name)
end

return M
