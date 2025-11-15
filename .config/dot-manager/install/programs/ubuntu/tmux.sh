#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_tmux() {
    print_step "Installing Tmux"

    log "info" "Installing dependencies"
    __install_package_apt libevent-dev ncurses-dev build-essential bison pkg-config

    log "info" "Cloning tmux repository"
    git clone https://github.com/tmux/tmux.git /tmp/tmux_installation
    cd /tmp/tmux_installation
    sh autogen.sh

    log "info" "Compiling tmux"
    ./configure --enable-sixel && make -j"$(nproc)" && sudo make install

    log "info" "Installing tmux plugins manager"
    if ! [ -d "$HOME"/.config/tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm
    fi

    log "info" "Installing tmux plugins"
    "$HOME"/.config/tmux/plugins/tpm/bin/install_plugins

    log "success" "Tmux installation completed"
}

install_tmux "$@"
