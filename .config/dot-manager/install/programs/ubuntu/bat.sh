#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_bat() {
	print_step "Installing Bat"

	local bat_version
	bat_version=$(__get_latest_release "sharkdp/bat")

	__download_install_deb "https://github.com/sharkdp/bat/releases/download/$bat_version/bat_${bat_version:1}_amd64.deb" "bat"

	if ! [ -d "$(bat --config-dir)" ]; then
		mkdir -p "$(bat --config-dir)/themes"
		wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
		wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
		wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
		wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
		bat cache --build
		log "success" "bat themes installed"
	fi
}

install_bat "$@"
