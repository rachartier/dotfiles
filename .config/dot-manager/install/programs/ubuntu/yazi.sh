#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_yazi() {
    YAZI_VERSION=$(__get_latest_release "sxyazi/yazi")

    print_step "Installing Yazi ${YAZI_VERSION:latest} ..."

    wget "https://github.com/sxyazi/yazi/releases/download/$YAZI_VERSION/yazi-x86_64-unknown-linux-musl.deb" -O /tmp/yazi.deb

    if sudo dpkg -i --force-depends /tmp/yazi.deb; then
        log "success" "Yazi installed."
    else
        log "error" "Yazi not installed."
    fi
}

install_yazi "$@"
