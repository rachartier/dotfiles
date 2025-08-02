#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_direnv() {
    print_step "Installing direnv"

    curl -sfL https://direnv.net/install.sh | bash

    log "success" "direnv installed."
}

install_direnv "$@"
