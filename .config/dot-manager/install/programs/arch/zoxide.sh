#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_zoxide() {
    print_step "Installing Zoxide"

    log "info" "Installing zoxide via pacman..."
    sudo pacman -S --noconfirm zoxide
}

install_zoxide "$@"
