#!/bin/bash

source "${0%/*}/../helper.sh"

install_eza() {
    print_step "Installing eza"

    local version
    version=$(__get_latest_release "eza-community/eza")

    log "download" "Downloading $version"
    __install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_eza "$@"
