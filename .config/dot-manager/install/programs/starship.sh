#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_starship() {
    print_step "Installing Starship"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available starship; then
        log "info" "Installing starship via pacman..."
        __install_package_auto starship
        log "success" "starship installed via pacman."
        return 0
    fi

    if curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y >/dev/null; then
        log "success" "starship installed."
    else
        log "error" "starship not installed."
    fi
}

install_starship "$@"
