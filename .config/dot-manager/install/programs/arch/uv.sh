#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_uv() {
    print_step "Installing uv"

    curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_uv "$@"
