#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_direnv() {
    print_step "Installing direnv"

    curl -sfL https://direnv.net/install.sh | bash

    log "success" "direnv installed."
}

install_direnv "$@"
