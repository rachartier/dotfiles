#!/bin/bash

filepath=$1
filename=$(basename -- "$filepath")
extension="${filename##*.}"

if [ -f "$filepath" ]; then
	if $(mimetype "$filepath" | grep ": image/" >/dev/null 2>&1); then
		"$HOME"/.local/bin/viu "$filepath"
	elif $(mimetype "$filepath" | grep "binary$" >/dev/null 2>&1); then
		echo "BINARY FILE"
	elif [ "$extension" = "md" ]; then
		shade="dark"

		if [ "$TMUX_THEME" = "catppuccin_latte.conf" ]; then
			shade="light"
		fi

		glow -p -w 100 -s light "$filepath"
	else
		theme="Catppuccin-macchiato"
		declare -A themes

		themes["catppuccin_macchiato.conf"]="Catppuccin-macchiato"
		themes["catppuccin_latte.conf"]="Catppuccin-latte"
		themes["catppuccin_mocha.conf"]="Catppuccin-mocha"
		themes["catppuccin_frappe.conf"]="Catppuccin-frappe"

		if [[ -v themes[$TMUX_THEME] ]]; then
			theme="${themes[$TMUX_THEME]}"
		fi

		bat --style=numbers --theme="$theme" --color=always --line-range :100 "$filepath"
	fi
elif [ -d "$filepath" ]; then
	eza --tree --level 1 --group-directories-first --color always --icons "$filepath"
else
	echo "Can't be previewed."
	# echo "$filepath" 2>/dev/null | head -200
fi
