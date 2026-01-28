#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_opencode() {
    print_step "Installing opencode"

    OPENCODE_VERSION=$(__get_latest_release "sst/opencode")
    OPENCODE_VERSION="${OPENCODE_VERSION:latest}"

    log "download" "Installing opencode ${OPENCODE_VERSION} ..."

    __install_package_release "https://github.com/sst/opencode/releases/latest/download/opencode-linux-x64.tar.gz" opencode
    #
    # log "info" "Downloading 'beads'"
    #
    # local bd_version
    # bd_version=$(__get_latest_release "steveyegge/beads")
    #
    # __install_package_release "https://github.com/steveyegge/beads/releases/latest/download/beads_${bd_version#v}_linux_amd64.tar.gz" bd
    #
    # log "info" "Installing 'beads-mcp' tool"
    # if command -v beads-mcp &>/dev/null; then
    #     log "info" "'beads-mcp' is already installed"
    #     if command -v uv &>/dev/null; then
    #         log "info" "Updating beads-mcp using uv"
    #         uv tool update beads-mcp
    #     elif command -v pipx &>/dev/null; then
    #         log "info" "Updating beads-mcp using pipx"
    #         pipx upgrade beads-mcp
    #     fi
    #     return
    # fi
    #
    # if ! command -v uv &>/dev/null; then
    #     log "info" "'uv' is not installed, testing with pipx"
    #     if command -v pipx &>/dev/null; then
    #         log "info" "Installing beads-mcp using pipx"
    #         pipx install beads-mcp
    #         log "info" "'uv' installed successfully"
    #     fi
    # else
    #     uv tool install beads-mcp
    # fi
}

install_opencode "$@"
