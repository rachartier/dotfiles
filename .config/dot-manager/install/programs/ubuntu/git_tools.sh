#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_git_tools() {
	print_step "Installing git tools"

	local git_delta_version
	git_delta_version=$(__get_latest_release "dandavison/delta")
	__download_install_deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${git_delta_version}_amd64.deb" "delta"
}

install_git_tools "$@"
