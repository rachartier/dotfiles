#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_devpod() {
    log "info" "Installing devpod..."

    curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
    devpod context set-options -o DOTFILES_URL="https://github.com/rachartier/devpod-dotfiles"
    log "info" "Devpod context set to use devpod-dotfiles repository"

    log "success" "Devpod installed."
}

install_devpod "$@"
