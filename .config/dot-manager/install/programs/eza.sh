#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_eza() {
    print_step "Installing eza"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available eza; then
        log "info" "Installing eza via pacman..."
        __install_package_auto eza
        log "success" "eza installed via pacman."
        return 0
    fi

    local version
    version=$(__get_latest_release "eza-community/eza")

    log "download" "Downloading $version"
    __install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_eza "$@"
