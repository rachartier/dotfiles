#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_copilot() {
    print_step "Installing Copilot"

    cd /tmp || exit

    local copilot_version
    copilot_version=$(__get_latest_release "github/copilot-cli")

    if command -v copilot &>/dev/null; then
        if [ -f "/usr/local/bin/copilot" ]; then
            log "info" "Removing old copilot installed via npm."
            sudo npm uninstall -g @github/copilot-cli
        fi
    fi

    log "info" "Installing copilot ${copilot_version} ..."
    __install_package_release "https://github.com/github/copilot-cli/releases/download/$copilot_version/copilot-linux-x64.tar.gz" "copilot"
}

install_copilot "$@"
