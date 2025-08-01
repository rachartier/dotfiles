#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_luarocks() {
    log "info" "Installing luarocks..."

    log "info" "Installing lua and luarocks via pacman..."
    sudo pacman -S --noconfirm lua luarocks

    # luarocks is now installed via pacman, no need for manual build
    log "success" "luarocks installed via pacman."
}

install_treesitter() {
    log "info" "Installing treesitter..."

    TS_VERSION=$(__get_latest_release "tree-sitter/tree-sitter")

    __install_package_release "https://github.com/tree-sitter/tree-sitter/releases/download/$TS_VERSION/tree-sitter-linux-x64.gz" "tree-sitter"
}

install_nvim() {
    print_step "Installing Neovim"
    local version=${1:-"stable"}

    log "info" "Installing Neovim, Lua, Luarocks, and python-pynvim via pacman..."
    sudo pacman -S --noconfirm neovim lua luarocks python-pynvim

    if [ ! -f "$HOME/.local/share/nvim/site/spell/fr.utf-8.spl" ]; then
        mkdir -p ~/.local/share/nvim/site/spell
        wget https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl \
            -O ~/.local/share/nvim/site/spell/fr.utf-8.spl
    fi

    log "info" "Installing luarocks"
    install_luarocks >/dev/null

    log "info" "Updating plugins"
    /opt/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" "+qall" >/dev/null

    log "success" "Neovim installation completed"
}

install_luarocks
install_treesitter
install_nvim "$@"
