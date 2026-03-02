#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_github_gh() {
	print_step "Installing GitHub CLI"

	local gh_version
	gh_version=$(__get_latest_release "cli/cli")
	gh_version="${gh_version:1}"

	if gh --version 2>/dev/null | grep -q "gh version $gh_version"; then
		log "info" "gh $gh_version already installed"
	else
		__download_install_deb "https://github.com/cli/cli/releases/latest/download/gh_${gh_version}_linux_amd64.deb" "gh"
	fi

	if ! gh auth status >/dev/null 2>&1; then
		log "info" "Please authenticate with gh"
		gh auth login
	fi

	if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
		gh extension upgrade gh-copilot >/dev/null 2>&1
	else
		gh extension install github/gh-copilot >/dev/null 2>&1
	fi
}

install_github_gh "$@"
