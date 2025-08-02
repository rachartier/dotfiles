#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_starship() {
    print_step "Installing Starship"

    log "info" "Installing starship via pacman..."
    sudo pacman -S --noconfirm starship
}

install_starship "$@"
