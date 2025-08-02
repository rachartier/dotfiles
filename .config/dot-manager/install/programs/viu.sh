#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_viu() {
    print_step "Installing Viu"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available viu; then
        log "info" "Installing viu via pacman..."
        __install_package_auto viu
        log "success" "viu installed via pacman."
        return 0
    fi

    local version
    version=$(__get_latest_release "atanunq/viu")

    log "download" "Installing viu $version ..."

    __install_package_release "https://github.com/atanunq/viu/releases/latest/download/viu-x86_64-unknown-linux-musl" viu
}

install_viu "$@"
