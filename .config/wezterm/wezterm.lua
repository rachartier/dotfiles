local wezterm = require("wezterm")

local config = {}

config.automatically_reload_config = true
config.color_scheme = "Catppuccin Macchiato" -- or Macchiato, Frappe, Latte
config.default_domain = "WSL:Ubuntu"
config.font = wezterm.font("CaskaydiaCove NF", { stretch = "UltraCondensed" })
config.font_size = 16
config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("CaskaydiaCove NF", { weight = "Bold", stretch = "UltraCondensed" }),
	},
	--
	-- {
	--     italic = true,
	--     font = wezterm.font("Operator Mono Book", { weight = "Bold", italic = true }),
	-- },
	-- {
	--     intensity = "Bold",
	--     italic = true,
	--     font = wezterm.font("Operator Mono Medium Italic", { weight = "ExtraBlack", italic = true }),
	-- },
}
config.harfbuzz_features = { "calt=1", "ss01=1" }
config.line_height = 1
config.underline_thickness = "0.125cell"
-- config.underline_position = "-0.25cell"
config.enable_kitty_graphics = true
config.allow_square_glyphs_to_overflow_width = "Always"

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%"
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = 0,
	bottom = "0.15cell",
}
-- config.window_background_opacity = 0
-- config.win32_system_backdrop = "Acrylic"

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

return config
