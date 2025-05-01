#!/bin/bash

source "${0%/*}/../../helper.sh"

install_luarocks() {
    log "info" "Installing luarocks..."

    __install_package_apt lua5.1
    __install_package_apt liblua5.1-dev

    wget -nv -q https://luarocks.org/releases/luarocks-3.11.1.tar.gz &&
        tar zxpf luarocks-3.11.1.tar.gz &&
        cd luarocks-3.11.1 &&
        ./configure && make && sudo make install
}

install_nvim() {
    print_step "Installing Neovim"
    local version=${1:-"nightly"}

    log "info" "Removing existing Neovim installation"
    sudo apt-get autoremove neovim -y >/dev/null

    if [ -f "$HOME/.local/bin/nvim" ]; then
        rm "$HOME/.local/bin/nvim"
    fi

    log "download" "Downloading Neovim $version"
    cd /tmp || exit 1
    local url="https://github.com/neovim/neovim/releases/download/$version/nvim-linux-x86_64.tar.gz"
    wget -q "$url" -O nvim-linux64.tar.gz >/dev/null

    log "info" "Installing Neovim"
    sudo rm -rf /opt/nvim-linux-x86_64/
    sudo tar -C /opt -xzf nvim-linux64.tar.gz

    # __install_package_apt python3-pynvim

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

install_luarocks "$@"
install_nvim "$@"
