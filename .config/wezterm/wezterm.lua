local wezterm = require("wezterm")
local config = {}

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		wezterm.log_error("File not found: " .. path)
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

config.automatically_reload_config = true
config.default_domain = "WSL:Ubuntu"

-- config.font = wezterm.font_with_fallback({ "Agave", "Symbols Nerd Font" })
-- config.font = wezterm.font_with_fallback({ "Cascadia Code", "Symbols Nerd Font" })
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font" })

-- config.font = wezterm.font("Agave")
-- config.font = wezterm.font("CaskaydiaCove NF", { weight = "Regular" })
-- config.font = wezterm.font("Agave Nerd Font")
-- config.font = wezterm.font("Hurmit Nerd Font")
-- config.font = wezterm.font("Monaspace Argon")

config.font_size = 12
config.font_rules = {
	-- {
	--     italic = true,
	--     font = wezterm.font("Cascadia Code", { weight = "Regular", italic = true }),
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
config.harfbuzz_features = { "calt=1", "ss01=1", "liga=1", "clig=1" }
config.line_height = 1
config.underline_thickness = "1.5pt"
config.underline_position = "-1.5pt"
config.enable_kitty_graphics = true
config.allow_square_glyphs_to_overflow_width = "Always"
config.bold_brightens_ansi_colors = "BrightAndBold"

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%"
config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "0.2cell",
	bottom = "0.1pt",
}
config.win32_system_backdrop = "Acrylic"

-- config.win32_acrylic_accent_color = "rgba(36, 39, 58, 0.60)"
-- config.window_background_opacity = 0.0
config.window_background_opacity = 0.85

config.window_close_confirmation = "NeverPrompt"

local windows_user = os.getenv("USERNAME")
local cache_path = "C:/Users/" .. windows_user .. "/AppData/Local/Temp/windows-tmux-theme.cache"

wezterm.add_to_config_reload_watch_list(cache_path)
local tmux_theme = read_file(cache_path)

if tmux_theme ~= nil then
	tmux_theme = tmux_theme:gsub("[\r\n]", "")
end

local theme = "Catppuccin Macchiato"

if tmux_theme == "catppuccin_macchiato.conf" then
	theme = "Catppuccin Macchiato"
elseif tmux_theme == "catppuccin_latte.conf" then
	theme = "Catppuccin Latte"
end

local custom = wezterm.color.get_builtin_schemes()[theme]
-- custom.ansi[6] = "#c6a0f6"
-- custom.ansi[7] = "#7dc4e4"
-- custom.brights[6] = "#c6a0f6"
-- custom.brights[7] = "#7dc4e4"

config.color_schemes = {
	["CustomCatppuccin"] = custom,
}
config.color_scheme = "CustomCatppuccin"

return config
