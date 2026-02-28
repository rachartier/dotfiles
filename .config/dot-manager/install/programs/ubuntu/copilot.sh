#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_copilot() {
	print_step "Installing Copilot"

	if [ -f "/usr/local/bin/copilot" ]; then
		sudo npm uninstall -g @github/copilot-cli >/dev/null 2>&1
	fi

	local copilot_version
	copilot_version=$(__get_latest_release "github/copilot-cli")

	__install_package_release "https://github.com/github/copilot-cli/releases/download/$copilot_version/copilot-linux-x64.tar.gz" "copilot"
}

install_copilot "$@"
