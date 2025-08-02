#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fd_find() {
    log "info" "Installing fd-find..."

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available fd; then
        log "info" "Installing fd via pacman..."
        __install_package_auto fd
        log "success" "fd installed via pacman."
        return 0
    fi

    local fd_version
    fd_version=$(__get_latest_release "sharkdp/fd")

    __install_package_release "https://github.com/sharkdp/fd/releases/latest/download/fd-${fd_version}-x86_64-unknown-linux-gnu.tar.gz" fd
}

install_fd_find "$@"
