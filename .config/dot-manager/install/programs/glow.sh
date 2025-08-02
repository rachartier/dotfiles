#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_glow() {
    print_step "Installing Glow"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available glow; then
        log "info" "Installing glow via pacman..."
        __install_package_auto glow
        log "success" "glow installed via pacman."
        return 0
    fi

    local glow_version
    glow_version=$(__get_latest_release "charmbracelet/glow")
    glow_version=${glow_version#v}

    log "download" "Installing glow..."
    __download_install_deb "https://github.com/charmbracelet/glow/releases/download/v${glow_version}/glow_${glow_version}_amd64.deb" glow
}

install_glow "$@"
