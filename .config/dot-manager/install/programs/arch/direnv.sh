#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_direnv() {
    print_step "Installing direnv"

    log "info" "Installing direnv via pacman..."
    sudo pacman -S --noconfirm direnv
}

install_direnv "$@"
