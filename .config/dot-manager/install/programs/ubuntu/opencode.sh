#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_opencode() {
    print_step "Installing opencode"

    curl -fsSL https://opencode.ai/v2/install | bash
}

install_opencode "$@"
