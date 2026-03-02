#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_opencode() {
	print_step "Installing opencode"

	__install_package_release "https://github.com/sst/opencode/releases/latest/download/opencode-linux-x64.tar.gz" opencode
}

install_opencode "$@"
