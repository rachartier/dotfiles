#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fd_find() {
    log "info" "Installing fd-find..."

    log "info" "Installing fd via pacman..."
    sudo pacman -S --noconfirm fd
}

install_fd_find "$@"
