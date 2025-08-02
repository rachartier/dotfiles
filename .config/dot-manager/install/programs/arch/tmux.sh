#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_tmux() {
    print_step "Installing Tmux"
    log "info" "Installing tmux via pacman..."
    sudo pacman -S --noconfirm tmux

    log "info" "Installing tmux plugins manager"
    if ! [ -d "$HOME"/.config/tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm
    fi

    log "info" "Installing tmux plugins"
    "$HOME"/.config/tmux/plugins/tpm/bin/install_plugins

    log "success" "Tmux installation completed"
}

install_tmux "$@"
