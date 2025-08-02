#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fzf() {
    print_step "Installing Fzf"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available fzf; then
        log "info" "Installing fzf via pacman..."
        __install_package_auto fzf
        log "success" "fzf installed via pacman."
        return 0
    fi

    if [ -d "$HOME/.fzf/" ]; then
        cd ~/.fzf || return 0
        git pull --quiet
        if yes | ./install; then
            log "success" "fzf updated."
        else
            log "error" "fzf not updated."
        fi
        return 0
    fi

    log "info" "Cloning fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null

    log "info" "Installing fzf..."
    yes | ~/.fzf/install >/dev/null
}

install_fzf "$@"
