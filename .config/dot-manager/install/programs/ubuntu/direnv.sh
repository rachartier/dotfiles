#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_direnv() {
	print_step "Installing direnv"

	if ! curl -sfL https://direnv.net/install.sh | bash >/dev/null 2>&1; then
		log "error" "direnv installation failed"
		return 1
	fi

	log "success" "direnv installed in ~/.local/bin/"
}

install_direnv "$@"
