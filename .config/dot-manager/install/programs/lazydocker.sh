#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_lazydocker() {
    print_step "Installing Lazydocker"

    LAZYDOCKER_VERSION=$(__get_latest_release "jesseduffield/lazydocker")
    LAZYDOCKER_VERSION="${LAZYDOCKER_VERSION:1}"

    log "download" "Installing lazydocker ${LAZYDOCKER_VERSION} ..."

    if [ -f "/usr/local/bin/lazydocker" ]; then
        log "info" "Removing old lazydocker symlink."
        sudo rm "/usr/local/bin/lazydocker"
    fi

    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" lazydocker
    log "info" "lazydocker installed."
}

install_lazydocker "$@"
