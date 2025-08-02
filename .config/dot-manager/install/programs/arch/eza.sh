#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_eza() {
    print_step "Installing eza"

    log "info" "Installing eza via pacman..."
    sudo pacman -S --noconfirm eza
}

install_eza "$@"
