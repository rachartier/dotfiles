#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_chafa() {
    log "info" "Installing chafa..."

    cd /tmp

    __install_package_apt "libfreetype6-dev"

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
