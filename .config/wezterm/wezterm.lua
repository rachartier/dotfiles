local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.max_fps = 165

config.check_for_updates = true
config.automatically_reload_config = true

if not os.getenv("WSL_DISTRO_NAME") then
	config.default_domain = "WSL:Ubuntu"
end

-- config.font = wezterm.font_with_fallback({ "Agave", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Cascadia Code", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "IBM Plex Mono", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Monaspace Neon", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "MonoLisa", "Symbols Nerd Font" })
config.font = wezterm.font_with_fallback({ "Berkeley Mono", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "CommitMono", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "0xProto", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Fantasque Sans Mono", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Cartograph CF", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Maple Mono NF", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "IBM Plex Mono", "Symbols Nerd Font" })
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"

config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Normal"
-- config.cell_width = 1
config.line_height = 1.0
config.font_size = 14
config.font_rules = {
	-- {
	-- 	italic = true,
	-- 	font = wezterm.font("MonoLisa", { weight = "Regular", italic = true }),
	-- 	-- font = wezterm.font("Cascadia Code", { weight = "Regular", italic = true }),
	-- 	-- font = wezterm.font("Monaspace Radon", { weight = "Regular", italic = true }),
	-- },
	--
	-- {
	-- 	italic = true,
	-- 	font = wezterm.font("CaskaydiaCove NF", { italic = true }),
	-- },
	-- {
	--     intensity = "Bold",
	--     italic = true,
	--     font = wezterm.font("Operator Mono Medium Italic", { weight = "ExtraBlack", italic = true }),
	-- },
}

-- == ~= != <= >= #################### 00000 =================> ==>
config.harfbuzz_features = {
	"zero=1",
	"ss01=1",
	"ss02=1",
	"ss03=1",
	-- "ss04=0",
	-- "ss05=1",
	-- "ss07=1",
	-- "ss08=1",
	-- "ss09=1",
	"liga=1",
	"calt=1",
	"clig=1",
}

config.underline_thickness = "0.12cell"
config.underline_position = "-1pt"
config.allow_square_glyphs_to_overflow_width = "Always"
config.bold_brightens_ansi_colors = "BrightAndBold"

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%"
config.window_padding = {
	-- left = "2cell",
	-- right = "2cell",
	top = 4,
	bottom = 0,
}
config.win32_system_backdrop = "Acrylic"
-- config.win32_system_backdrop = "Mica"

-- config.win32_acrylic_accent_color = "rgba(36, 39, 58, 0)"
-- config.window_background_opacity = 0.0
-- config.window_background_opacity = 0.88
config.window_background_opacity = 1

config.window_close_confirmation = "NeverPrompt"
local theme = "Catppuccin Macchiato"
--
-- local custom = wezterm.color.get_builtin_schemes()[theme]
-- -- custom.ansi[6] = "#c6a0f6"
-- -- custom.ansi[7] = "#7dc4e4"
-- -- custom.brights[6] = "#c6a0f6"
-- -- custom.brights[7] = "#7dc4e4"
--
-- config.color_schemes = {
-- 	["CustomCatppuccin"] = custom,
-- }
config.color_scheme = theme

config.mouse_bindings = {
	-- CTRL-Click open hyperlinks
	{
		mouse_reporting = true,
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Scrolling up while holding CTRL increases the font size
	{
		mouse_reporting = true,
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},

	-- Scrolling down while holding CTRL decreases the font size
	{
		mouse_reporting = true,
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},

	-- CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Scrolling up while holding CTRL increases the font size
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},

	-- Scrolling down while holding CTRL decreases the font size
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
}

config.term = "wezterm"

return config
