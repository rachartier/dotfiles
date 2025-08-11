#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_tmux() {
    print_step "Installing Tmux"
    TMUX_VERSION=$(__get_latest_release "tmux/tmux")

    log "info" "Installing dependencies"
    __install_package_apt libevent-dev ncurses-dev build-essential bison pkg-config

    cd /tmp || exit 1
    wget -nv -q "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz" -O tmux.tar.gz || {
        log "error" "Failed to download tmux source code"
        exit 1
    }
    tar -xzvf tmux.tar.gz >/dev/null
    cd "tmux-$TMUX_VERSION" || exit

    log "info" "Compiling tmux"
    ./configure --enable-sixel >/dev/null

    log "info" "Installing tmux"
    make >/dev/null && sudo make install >/dev/null

    log "info" "Installing tmux plugins manager"
    if ! [ -d "$HOME"/.config/tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm
    fi

    log "info" "Installing tmux plugins"
    "$HOME"/.config/tmux/plugins/tpm/bin/install_plugins

    log "success" "Tmux installation completed"
}

install_tmux "$@"
