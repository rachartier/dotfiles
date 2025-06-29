#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_fonts() {
    local cmd="$1"

    cd /tmp
    case "$cmd" in
    "update")
        log "info" "Installing Nerd Fonts..."
        if [ -d /tmp/nerdfonts ]; then
            log "info" "Removing old Nerd Fonts directory."
            rm -rf /tmp/nerdfonts
        fi

        wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.zip" &&
            unzip NerdFontsSymbolsOnly.zip -d /tmp/nerdfonts &&
            mkdir -p "$HOME/.local/share/fonts" &&
            cp /tmp/nerdfonts/*.ttf "$HOME/.local/share/fonts" &&
            rm -rf /tmp/nerdfonts NerdFontsSymbolsOnly.zip
        fc-cache -fv
        log "info" "Nerd Fonts installed successfully."
        ;;
    esac
}

install_fonts "$@"
