local wezterm = require("wezterm")
local config = {}

config.automatically_reload_config = true
config.default_domain = "WSL:Ubuntu"
config.font = wezterm.font("CaskaydiaCove NF", { weight = "Regular" })
-- config.font = wezterm.font("Monaspace Argon")
config.font_size = 14
config.font_rules = {
	-- {
	--     intensity = "Bold",
	--     italic = false,
	--     font = wezterm.font("CaskaydiaCove NF", { weight = "Bold", stretch = "UltraCondensed" }),
	-- },
	--
	-- {
	--     italic = true,
	--     font = wezterm.font("CaskaydiaCove NF", { weight = "Regular", italic = true }),
	-- },
	-- {
	--     intensity = "Bold",
	--     italic = true,
	--     font = wezterm.font("Operator Mono Medium Italic", { weight = "ExtraBlack", italic = true }),
	-- },
}
config.harfbuzz_features = { "calt=1", "ss01=1", "liga=1", "clig=1" }
config.line_height = 1
config.underline_thickness = "2pt"
-- config.underline_position = "-0.25cell"
config.enable_kitty_graphics = true
config.allow_square_glyphs_to_overflow_width = "Always"

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%"
config.window_padding = {
	left = "4cell",
	right = "4cell",
	top = "0.5cell",
	bottom = "0.4cell",
}
config.window_background_opacity = 0.4
-- config.text_background_opacity = 0.8
config.win32_system_backdrop = "Acrylic"

config.window_close_confirmation = "NeverPrompt"

config.ssh_domains = {
	{
		name = "local.wsl",
		-- The hostname or address to connect to. Will be used to match settings
		-- from your ssh config file
		remote_address = "172.19.181.196",
		-- The username to use on the remote host
		username = "rachartier",
	},
}

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
custom.ansi[6] = "#c6a0f6"
custom.ansi[7] = "#7dc4e4"
custom.brights[6] = "#c6a0f6"
custom.brights[7] = "#7dc4e4"

config.color_schemes = {
	["CustomCatppuccin"] = custom,
}
config.color_scheme = "CustomCatppuccin"
-- config.color_scheme = "Catppuccin Macchiato" -- or Macchiato, Frappe, Latte

return config
