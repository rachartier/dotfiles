#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_tmux() {
	print_step "Installing tmux"

	__install_package libevent-dev ncurses-dev build-essential bison pkg-config

	local version
	version=$(__get_latest_release "tmux/tmux")

	cd /tmp || exit 1
	log "download" "Downloading tmux $version..."
	wget -nv "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz" >>"$DOT_MANAGER_LOG" 2>&1 || return 1
	tar -xf "tmux-${version}.tar.gz"
	cd "tmux-${version}" || exit 1

	./configure --enable-sixel >>"$DOT_MANAGER_LOG" 2>&1 && make -j"$(nproc)" >>"$DOT_MANAGER_LOG" 2>&1 && sudo make install >>"$DOT_MANAGER_LOG" 2>&1

	if ! [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
		git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" >>"$DOT_MANAGER_LOG" 2>&1
	fi

	"$HOME/.config/tmux/plugins/tpm/bin/install_plugins" >>"$DOT_MANAGER_LOG" 2>&1

	log "success" "tmux $version installed in /usr/local/bin/"
}

install_tmux "$@"
