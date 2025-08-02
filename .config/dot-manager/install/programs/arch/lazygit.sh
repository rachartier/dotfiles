#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_lazygit() {
    print_step "Installing Lazygit"

    log "info" "Installing lazygit via pacman..."
    sudo pacman -S --noconfirm lazygit
}

install_lazygit "$@"
