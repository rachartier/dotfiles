#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_lazydocker() {
    print_step "Installing Lazydocker"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available lazydocker; then
        log "info" "Installing lazydocker via pacman..."
        __install_package_auto lazydocker
        log "success" "lazydocker installed via pacman."
        return 0
    fi

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
