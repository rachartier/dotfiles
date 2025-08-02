#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fzf() {
    print_step "Installing Fzf"

    log "info" "Installing fzf via pacman..."
    sudo pacman -S --noconfirm fzf
}

install_fzf "$@"
