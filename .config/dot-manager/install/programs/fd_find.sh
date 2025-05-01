#!/bin/bash

source "${0%/*}/../../helper.sh"

install_fd_find() {
    log "info" "Installing fd-find..."

    local fd_version
    fd_version=$(__get_latest_release "sharkdp/fd")

    __install_package_release "https://github.com/sharkdp/fd/releases/latest/download/fd-${fd_version}-x86_64-unknown-linux-gnu.tar.gz" fd
}

install_fd_find "$@"
