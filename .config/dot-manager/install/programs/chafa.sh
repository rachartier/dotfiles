#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_chafa() {
    log "info" "Installing chafa..."

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available chafa; then
        log "info" "Installing chafa via pacman..."
        __install_package_auto chafa
        log "success" "chafa installed via pacman."
        return 0
    fi

    cd /tmp

    __install_package_auto "libfreetype6-dev"

    if [ -d "chafa" ]; then
        log "info" "Removing old chafa directory."
        rm -rf chafa
    fi

    git clone https://github.com/hpjansson/chafa &&
        cd chafa &&
        ./autogen.sh &&
        make &&
        sudo make install
}

install_chafa "$@"
