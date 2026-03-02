#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_uv() {
	print_step "Installing uv"

	if ! curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1; then
		log "error" "uv installation failed"
		return 1
	fi

	log "success" "uv installed in ~/.local/bin/"
}

install_uv "$@"
