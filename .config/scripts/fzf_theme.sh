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
	win_cfg=$(wslpath -w "$HOME/.config/wezterm/wezterm.lua")
	powershell.exe -NoProfile -Command "(Get-Item '$win_cfg').LastWriteTime = Get-Date" &>/dev/null &
fi

# --- nvim (reload theme in all running instances) ---
for socket in /run/user/$(id -u)/nvim.*.0; do
	[ -S "$socket" ] && nvim --server "$socket" --remote-expr \
		'execute("lua require(\"themes\").reload_system_theme()")' 2>/dev/null &
done
wait
