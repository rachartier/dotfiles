#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_copilot_cli() {
    log "info" "Installing copilot-cli..."

    if [ -f "$HOME/.local/bin/copilot-cli" ]; then
        log "info" "Removing old copilot-cli symlink."
        rm "$HOME/.local/bin/copilot-cli"
    fi

    __install_package_release "https://github.com/rachartier/copilot-cli/releases/latest/download/copilot-cli.tar.gz" copilot-cli
}

install_copilot_cli "$@"
