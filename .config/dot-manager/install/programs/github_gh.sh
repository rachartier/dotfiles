#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_github_gh() {
    log "info" "Installing gh"

    if [ -f "/etc/arch-release" ] && is_pacman_pkg_available github-cli; then
        log "info" "Installing gh via pacman..."
        __install_package_auto github-cli
        log "success" "gh installed via pacman."
        return 0
    fi

    local gh_version
    gh_version=$(__get_latest_release "cli/cli")
    gh_version="${gh_version:1}"

    # verify if current version is the same as the version to install, only if current version is installed
    if gh --version | grep -q "gh version $gh_version"; then
        log "info" "gh already installed."
    else
        __download_install_deb "https://github.com/cli/cli/releases/latest/download/gh_${gh_version}_linux_amd64.deb" "gh"
    fi

    gh auth status >/dev/null
    if [ "$?" -eq 0 ]; then
        log "info" "gh already authenticated."
    else
        log "info" "Please authenticate with gh."
        gh auth login
    fi

    if gh extension list | grep -q "gh-copilot"; then
        gh extension upgrade gh-copilot
    else
        gh extension install github/gh-copilot
    fi
}

install_github_gh "$@"
