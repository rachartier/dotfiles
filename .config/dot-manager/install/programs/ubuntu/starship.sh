#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_starship() {
	print_step "Installing starship"

	if curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y >/dev/null 2>&1; then
		log "success" "starship installed in ~/.local/bin/"
	else
		log "error" "starship installation failed"
		return 1
	fi
}

install_starship "$@"
