#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_bat() {
    print_step "Installing Bat"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available bat; then
        log "info" "Installing bat via pacman..."
        __install_package_auto bat
        log "success" "bat installed via pacman."
        return 0
    fi

    cd /tmp || exit

    local bat_version
    bat_version=$(__get_latest_release "sharkdp/bat")

    log "info" "Installing bat ${bat_version} ..."
    __download_install_deb "https://github.com/sharkdp/bat/releases/download/$bat_version/bat_${bat_version:1}_amd64.deb" "bat"

    if ! [ -d "$(bat --config-dir)" ]; then
        log "info" "Installing bat themes..."
        mkdir -p "$(bat --config-dir)/themes"
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
        wget -nvq -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

        log "success" "bat themes installed."
        bat cache --build
    fi
}

install_bat "$@"
