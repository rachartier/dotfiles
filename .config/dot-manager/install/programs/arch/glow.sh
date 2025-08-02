#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_glow() {
    print_step "Installing Glow"

    log "info" "Installing glow via pacman..."
    sudo pacman -S --noconfirm glow
}

install_glow "$@"
