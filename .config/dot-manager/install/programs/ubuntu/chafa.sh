#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_chafa() {
	print_step "Installing chafa"

	__install_package libfreetype6-dev

	cd /tmp || exit 1
	[ -d "chafa" ] && rm -rf chafa

	if git clone https://github.com/hpjansson/chafa >/dev/null 2>&1 &&
		cd chafa &&
		./autogen.sh >/dev/null 2>&1 &&
		make -j"$(nproc)" >/dev/null 2>&1 &&
		sudo make install >/dev/null 2>&1; then
		log "success" "chafa installed in /usr/local/"
	else
		log "error" "chafa installation failed"
		return 1
	fi
}

install_chafa "$@"
