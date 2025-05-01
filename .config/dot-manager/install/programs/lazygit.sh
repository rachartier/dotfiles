#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_lazygit() {
    print_step "Installing Lazygit"

    LAZYGIT_VERSION=$(__get_latest_release "jesseduffield/lazygit")
    LAZYGIT_VERSION="${LAZYGIT_VERSION:1}"

    log "download" "Installing lazygit ${LAZYGIT_VERSION} ..."

    if [ -f "/usr/local/bin/lazygit" ]; then
        log "info" "Removing old lazygit symlink."
        sudo rm "/usr/local/bin/lazygit"
    fi
    __install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit
}

install_lazygit "$@"
