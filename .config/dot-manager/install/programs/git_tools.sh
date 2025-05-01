#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_git_tools() {
    log "info" "Installing git-delta..."

    local git_delta_version
    git_delta_version=$(__get_latest_release "dandavison/delta")

    __download_install_deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${git_delta_version}_amd64.deb" "delta"

    local git_graph_version
    git_graph_version=$(__get_latest_release "mlange-42/git-graph")
    log "info" "Installing git-graph ${git_graph_version}..."

    __install_package_release "https://github.com/mlange-42/git-graph/releases/latest/download/git-graph-$git_graph_version-linux-amd64.tar.gz" git-graph
}

install_git_tools "$@"
