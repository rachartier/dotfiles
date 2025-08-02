#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_github_gh() {
    log "info" "Installing gh"

    log "info" "Installing github-cli via pacman..."
    sudo pacman -S --noconfirm github-cli
}

install_github_gh "$@"
