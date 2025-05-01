#!/bin/env bash

source "${0%/*}/../../helper.sh"

install_win32yank() {
    print_step "Installing win32yank"

    log "download" "Installing win32yank..."
    __install_package_release "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip" win32yank.exe
}

install_win32yank "$@"
