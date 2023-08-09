local wezterm = require("wezterm")

return {
    automatically_reload_config = true,
    color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte
    default_domain = "WSL:Ubuntu",
    font = wezterm.font("CaskaydiaCove NF"),
    font_size = 13,
    enable_kitty_graphics = true,
    allow_square_glyphs_to_overflow_width = "Always",

    hide_tab_bar_if_only_one_tab = true,
    adjust_window_size_when_changing_font_size = false,
    selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    front_end = "OpenGL",
    window_close_confirmation = "NeverPrompt",

    ssh_domains = {
        {
            name = "local.wsl",
            -- The hostname or address to connect to. Will be used to match settings
            -- from your ssh config file
            remote_address = "172.19.181.196",
            -- The username to use on the remote host
            username = "rachartier",
        },
    },
}
