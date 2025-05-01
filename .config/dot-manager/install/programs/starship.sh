#!/bin/bash

source "${0%/*}/../../helper.sh"

install_starship() {
    print_step "Installing Starship"

    if curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y >/dev/null; then
        log "success" "starship installed."
    else
        log "error" "starship not installed."
    fi
}

install_starship "$@"
