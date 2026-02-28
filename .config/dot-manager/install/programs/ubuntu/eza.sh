#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_eza() {
	print_step "Installing eza"

	__install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_eza "$@"
