#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_lazygit() {
	print_step "Installing lazygit"

	local version
	version=$(__get_latest_release "jesseduffield/lazygit")
	version="${version:1}"

	[ -f "/usr/local/bin/lazygit" ] && sudo rm "/usr/local/bin/lazygit"

	__install_package_release "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz" lazygit
}

install_lazygit "$@"
