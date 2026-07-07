#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fonts() {
	cd /tmp || exit 1
	print_step "Installing Nerd Fonts"
	[ -d /tmp/nerdfonts ] && rm -rf /tmp/nerdfonts

	if wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.zip" &&
		unzip -oq NerdFontsSymbolsOnly.zip -d /tmp/nerdfonts &&
		mkdir -p "$HOME/.local/share/fonts" &&
		cp /tmp/nerdfonts/*.ttf "$HOME/.local/share/fonts" &&
		rm -rf /tmp/nerdfonts NerdFontsSymbolsOnly.zip; then
		fc-cache -fv >>"$DOT_MANAGER_LOG" 2>&1
		log "success" "Nerd Fonts installed"
	else
		log "error" "Nerd Fonts installation failed"
		return 1
	fi
}

[ "$1" = "update" ] && install_fonts
