#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_opencode() {
    print_step "Installing opencode"

    OPENCODE_VERSION=$(__get_latest_release "sst/opencode")
    OPENCODE_VERSION="${OPENCODE_VERSION:latest}"

    log "download" "Installing opencode ${OPENCODE_VERSION} ..."

    __install_package_release "https://github.com/sst/opencode/releases/latest/download/opencode-linux-x64.zip" opencode
}

install_opencode "$@"
