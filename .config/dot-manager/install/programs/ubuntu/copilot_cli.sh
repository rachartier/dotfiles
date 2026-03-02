#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_copilot_cli() {
	print_step "Installing copilot-cli"

	[ -f "$HOME/.local/bin/copilot-cli" ] && rm "$HOME/.local/bin/copilot-cli"

	__install_package_release "https://github.com/rachartier/copilot-cli/releases/latest/download/copilot-cli-linux.tar.gz" copilot-cli
}

install_copilot_cli "$@"
