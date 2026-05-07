#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_copilot() {
	print_step "Installing Copilot"

	if [ -f "/usr/local/bin/copilot" ]; then
		sudo npm uninstall -g @github/copilot-cli >/dev/null 2>&1
	fi

	local copilot_version
	copilot_version=$(__get_latest_release "github/copilot-cli")

	local rtk_version
	rtk_version=$(__get_latest_release "rtk-ai/rtk")

	__install_package_release "https://github.com/github/copilot-cli/releases/download/$copilot_version/copilot-linux-x64.tar.gz" "copilot"

	print_step "Installing RTK ($rtk_version)"
	__install_package_release "https://github.com/rtk-ai/rtk/releases/download/$rtk_version/rtk-x86_64-unknown-linux-musl.tar.gz" "rtk"
}

install_copilot "$@"
