#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_zoxide() {
    print_step "Installing Zoxide"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available zoxide; then
        log "info" "Installing zoxide via pacman..."
        __install_package_auto zoxide
        log "success" "zoxide installed via pacman."
        return 0
    fi

    log "info" "Installing zoxide..."

    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null

    log "success" "zoxide installed."
}

install_zoxide "$@"
