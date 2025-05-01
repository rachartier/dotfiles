#!/bin/bash

source "${0%/*}/../../helper.sh"

install_node_js() {
    print_step "Installing Node.js LTS"

    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s lts >/dev/null
}

install_node_js "$@"
