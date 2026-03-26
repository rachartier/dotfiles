#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_zk() {
    print_step "Installing zk"

    ZK_VERSION=$(__get_latest_release "zk-org/zk")
    ZK_VERSION="${ZK_VERSION:1}"

    __install_package_release "https://github.com/zk-org/zk/releases/latest/download/zk-v${ZK_VERSION}-linux-amd64.tar.gz" zk

    log "success" "zk installed in ~/.local/bin/"
}

install_zk "$@"
