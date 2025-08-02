#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_direnv() {
    print_step "Installing direnv"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available direnv; then
        log "info" "Installing direnv via pacman..."
        __install_package_auto direnv
        log "success" "direnv installed via pacman."
        return 0
    fi

    curl -sfL https://direnv.net/install.sh | bash

    log "success" "direnv installed."
}

install_direnv "$@"
