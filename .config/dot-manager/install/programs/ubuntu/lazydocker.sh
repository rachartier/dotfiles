#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_lazydocker() {
	print_step "Installing Lazydocker"

	LAZYDOCKER_VERSION=$(__get_latest_release "jesseduffield/lazydocker")
	LAZYDOCKER_VERSION="${LAZYDOCKER_VERSION:1}"

	if [ -f "/usr/local/bin/lazydocker" ]; then
		sudo rm "/usr/local/bin/lazydocker"
	fi

	__install_package_release "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" lazydocker
}

install_lazydocker "$@"
