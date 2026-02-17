#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_yazi() {
    print_step "Installing Yazi ..."

    if dpkg -l | grep yazi; then
        sudo dpkg --remove --force-remove-reinstreq yazi
    fi

    # Install the binary directly
    curl -fsSL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip -o /tmp/yazi.zip
    unzip /tmp/yazi.zip -d /tmp/yazi
    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/
    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/ya /usr/local/bin/
    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/completions/_yazi /usr/share/zsh/site-functions/_yazi
    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/completions/_ya /usr/share/zsh/site-functions/_ya
}

install_yazi "$@"
