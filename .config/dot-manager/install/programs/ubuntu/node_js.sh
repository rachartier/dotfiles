#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_node_js() {
	print_step "Installing Node.js LTS"

	if ! curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s lts >/dev/null 2>&1; then
		log "error" "Node.js installation failed"
		return 1
	fi

	log "success" "Node.js LTS installed in /usr/local/"
}

install_node_js "$@"
