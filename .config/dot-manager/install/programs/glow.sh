#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_glow() {
    print_step "Installing Glow"

    local glow_version
    glow_version=$(__get_latest_release "charmbracelet/glow")
    glow_version=${glow_version#v}

    log "download" "Installing glow..."
    __download_install_deb "https://github.com/charmbracelet/glow/releases/download/v${glow_version}/glow_${glow_version}_amd64.deb" glow
}

install_glow "$@"
