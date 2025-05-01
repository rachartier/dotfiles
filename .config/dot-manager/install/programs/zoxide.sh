#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_zoxide() {
    print_step "Installing Zoxide"

    log "info" "Installing zoxide..."

    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null

    log "success" "zoxide installed."
}

install_zoxide "$@"
