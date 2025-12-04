#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_copilot() {
    print_step "Installing Copilot"

    cd /tmp || exit

    local copilot_version
    copilot_version=$(__get_latest_release "github/copilot-cli")

    if command -v copilot &>/dev/null; then
        if [ -f "/usr/local/bin/copilot" ]; then
            log "info" "Removing old copilot installed via npm."
            sudo npm uninstall -g @github/copilot-cli
        fi
    fi

    log "info" "Installing copilot ${copilot_version} ..."
    __install_package_release "https://github.com/github/copilot-cli/releases/download/$copilot_version/copilot-linux-x64.tar.gz" "copilot"

    log "info" "Downloading 'beads'"

    local bd_version
    bd_version=$(__get_latest_release "steveyegge/beads")

    __install_package_release "https://github.com/steveyegge/beads/releases/latest/download/beads_${bd_version#v}_linux_amd64.tar.gz" bd

    log "info" "Installing 'beads-mcp' tool"
    if command -v beads-mcp &>/dev/null; then
        log "info" "'beads-mcp' is already installed"
        if command -v uv &>/dev/null; then
            log "info" "Updating beads-mcp using uv"
            uv tool update beads-mcp
        elif command -v pipx &>/dev/null; then
            log "info" "Updating beads-mcp using pipx"
            pipx upgrade beads-mcp
        fi
        return
    fi

    if ! command -v uv &>/dev/null; then
        log "info" "'uv' is not installed, testing with pipx"
        if command -v pipx &>/dev/null; then
            log "info" "Installing beads-mcp using pipx"
            pipx install beads-mcp
            log "info" "'uv' installed successfully"
        fi
    else
        uv tool install beads-mcp
    fi
}

install_copilot "$@"
