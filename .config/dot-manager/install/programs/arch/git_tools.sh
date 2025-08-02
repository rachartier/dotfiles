#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_git_tools() {
    print_step "Installing git-delta..."

    log "info" "Installing git-delta and git-graph via pacman..."
    sudo pacman -S --noconfirm git-delta git-graph
}

install_git_tools "$@"
