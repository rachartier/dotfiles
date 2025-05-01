#!/bin/bash

source "${0%/*}/../../helper.sh"

use_tool_dotnet() {
    if [ ! -f "$HOME/.dotnet" ]; then
        log "info" "Creating $HOME/.dotnet directory."
        mkdir -p "$HOME/.dotnet"
    fi

    local script_path="$DOT_MANAGER_CACHE_DIR/dotnet-install.sh"
    if [ ! -f "$script_path" ]; then
        log "info" "Downloading dotnet-install.sh script."
        wget -q "https://dot.net/v1/dotnet-install.sh" -O "$script_path"
        chmod +x "$script_path"
    fi

    log "info" "Running dotnet-install.sh script."
    bash "$script_path" "$@"
}

use_tool_dotnet "$@"
