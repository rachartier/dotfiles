#!/bin/bash

source "${0%/*}/../../helper.sh"

install_gitu() {
    print_step "Installing Gitu"

    local gitu_version
    gitu_version=$(__get_latest_release "altsem/gitu")

    log "download" "Installing gitu ${gitu_version} ..."
    if [ -f "$HOME/.local/bin/gitu" ]; then
        log "info" "Removing old gitu symlink."
        sudo rm "$HOME/.local/bin/gitu"
    fi

    __install_package_release "https://github.com/altsem/gitu/releases/latest/download/gitu-${gitu_version}-x86_64-unknown-linux-gnu.tar.gz" gitu
}

install_gitu "$@"
