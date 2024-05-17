#!/bin/bash

filepath=$1
filename=$(basename -- "$filepath")
extension="${filename##*.}"

if [ -f "$filepath" ]; then
	if $(file --mime "$filepath" | grep ": image/" >/dev/null 2>&1); then
		"$HOME"/.local/bin/viu "$filepath"
	elif $(file --mime "$filepath" | grep "binary$" >/dev/null 2>&1); then
		echo "BINARY FILE"
	elif [ "$extension" = "md" ]; then
		glow -p -w 100 -s dark "$filepath"
	else
		bat --style=numbers --color=always --line-range :500 "$filepath"
	fi
elif [ -d "$filepath" ]; then
	eza --tree --level 1 --group-directories-first --color always --icons "$filepath"
else
	echo "Can't be previewed."
	# echo "$filepath" 2>/dev/null | head -200
fi
