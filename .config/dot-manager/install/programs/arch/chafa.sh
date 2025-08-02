#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_chafa() {
    log "info" "Installing chafa..."

    log "info" "Installing chafa via pacman..."
    sudo pacman -S --noconfirm chafa
}

install_chafa "$@"
