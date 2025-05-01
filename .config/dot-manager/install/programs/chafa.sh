#!/bin/bash

source "${0%/*}/../../helper.sh"

install_chafa() {
    log "info" "Installing chafa..."

    cd /tmp

    git clone https://github.com/hpjansson/chafa &&
        cd chafa &&
        ./autogen.sh &&
        make &&
        sudo make install
}

install_chafa "$@"
