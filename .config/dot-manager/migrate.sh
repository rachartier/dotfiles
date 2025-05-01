#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

migrate_from_v1() {
    log "info" "Migrating from v1 to v2"

    if [ ! -d "$HOME/.local/bin" ]; then
        log "info" "Creating $HOME/.local/bin"
        mkdir -p "$HOME/.local/bin"
    fi

    dot_script_path="$HOME/.config/dot-manager/dot.sh"
    dot_script_link="$HOME/.local/bin/dot"

    if [ -L "$dot_script_link" ]; then
        log "info" "Removing old dot symlink"
        rm "$dot_script_link"
    fi

    if [ ! -L "$dot_script_link" ] || [ ! -e "$dot_script_link" ]; then
        log "info" "Creating new dot symlink"
        ln -s "$dot_script_path" "$dot_script_link"
        log "success" "Symlink created at $dot_script_link"
    fi
}

print_header "Migration Script"

if [ "$DOT_MANAGER_VERSION" = "2" ]; then
    migrate_from_v1
fi
