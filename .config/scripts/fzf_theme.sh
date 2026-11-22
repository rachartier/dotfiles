#!/bin/bash

THEMES_DIR="$HOME/.config/custom-themes"
CACHE_FILE="$THEMES_DIR/.current"

themes=$(ls "$THEMES_DIR"/*.sh 2>/dev/null | xargs -n1 basename | sed 's/\.sh$//')

if [ -z "$themes" ]; then
	echo "No themes found in $THEMES_DIR"
	exit 1
fi

selected=$(echo "$themes" | "$HOME/.fzf/bin/fzf" --preview '')

if [ -z "$selected" ]; then
	exit 0
fi

echo -n "$selected" >"$CACHE_FILE"

# Source theme for current shell env
. "$THEMES_DIR/$selected.sh"

# --- tmux ---
sed 's/^export //' "$THEMES_DIR/$selected.sh" >"$HOME/.config/tmux/conf/current_theme.conf"
tmux setenv THEME_NAME "$selected"
tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null

# --- wezterm ---
# WSL2 fs notifications don't reach Windows file watchers, so touch the config from Windows
if command -v wslpath &>/dev/null; then
	win_cfg=$(wslpath -w "C:/Users/Le_Bu/.wezterm.lua")
	powershell.exe -NoProfile -Command "(Get-Item '$win_cfg').LastWriteTime = Get-Date" &>/dev/null &
fi

# --- rio ---
# Rio runs on Windows and only watches its own config dir, so the theme is written there
rio_dir="/mnt/c/Users/Le_Bu/AppData/Local/rio"
if [ -d "$rio_dir" ]; then
	mkdir -p "$rio_dir/themes" "$rio_dir/shaders"
	cp "$HOME/.config/rio/shaders/gradient_warp.slang" "$rio_dir/shaders/"
	cat >"$rio_dir/shaders/gradient_warp.slangp" <<EOF
shaders = 1
shader0 = gradient_warp.slang
scale_type0 = viewport
filter_linear0 = false

BG_R = $((16#${COLOR_base:1:2}))
BG_G = $((16#${COLOR_base:3:2}))
BG_B = $((16#${COLOR_base:5:2}))
ALT_R = $((16#${COLOR_mantle:1:2}))
ALT_G = $((16#${COLOR_mantle:3:2}))
ALT_B = $((16#${COLOR_mantle:5:2}))
EOF
	cat >"$rio_dir/themes/current.toml" <<EOF
[colors]
background = "$COLOR_base"
foreground = "$COLOR_text"
cursor = "$COLOR_text"
selection-background = "$COLOR_surface"
selection-foreground = "$COLOR_text"
split = "$COLOR_muted"
tabs = "$COLOR_muted"
tabs-active = "$COLOR_text"

black = "$COLOR_base"
red = "$COLOR_red"
green = "$COLOR_green"
yellow = "$COLOR_yellow"
blue = "$COLOR_blue"
magenta = "$COLOR_mauve"
cyan = "$COLOR_teal"
white = "$COLOR_text"

light-black = "$COLOR_muted"
light-red = "$COLOR_red"
light-green = "$COLOR_green"
light-yellow = "$COLOR_yellow"
light-blue = "$COLOR_blue"
light-magenta = "$COLOR_mauve"
light-cyan = "$COLOR_teal"
light-white = "$COLOR_highlight"
EOF
	# Rio's watcher is not recursive: bump the themes dir so it sees a change
	touch "$rio_dir/themes"
fi

# --- nvim (reload theme in all running instances) ---
for socket in /run/user/$(id -u)/nvim.*.0; do
	[ -S "$socket" ] && nvim --server "$socket" --remote-expr \
		'execute("lua require(\"themes\").reload_system_theme()")' 2>/dev/null &
done
wait
