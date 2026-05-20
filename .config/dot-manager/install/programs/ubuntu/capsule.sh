#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_capsule() {
    curl -fsSL https://raw.githubusercontent.com/rachartier/capsule/main/install.sh | bash
}

install_capsule "$@"
