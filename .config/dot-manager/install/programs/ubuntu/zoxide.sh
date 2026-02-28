#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_zoxide() {
	print_step "Installing zoxide"

	if ! curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null 2>&1; then
		log "error" "zoxide installation failed"
		return 1
	fi

	log "success" "zoxide installed in ~/.local/bin/"
}

install_zoxide "$@"
