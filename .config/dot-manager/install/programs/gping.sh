#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_gping() {
    __install_package_apt "gping"
}

install_gping "$@"
