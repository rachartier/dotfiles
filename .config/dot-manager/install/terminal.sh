#!/bin/bash

source "${0%/*}/../helper.sh"

install_terminal() {
    local terminal_name="$1"

    cd /tmp
    case "$terminal_name" in
    "wezterm")
        log "info" "Installing wezterm..."
        __download_install_deb https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu24.04.deb wezterm
        ;;
    "kitty")
        log "info" "Installing kitty..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        if [ -L "$HOME/.local/bin/kitty" ]; then
            log "info" "Removing old kitty symlink."
            rm "$HOME/.local/bin/kitty"
        fi

        if [ -L "$HOME/.local/bin/kitten" ]; then
            log "info" "Removing old kitten symlink."
            rm "$HOME/.local/bin/kitten"
        fi

        ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
        ln -s ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
        ;;
    *)
        log "info" "Installing ghostty..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
        # git clone https://github.com/ghostty-org/ghostty
        # cd ghostty || return 1
        # __install_package_apt libgtk-4-dev libadwaita-1-dev
        # sudo snap install --beta zig --classic
        # sudo zig build -p /usr -Doptimize=ReleaseFast
        ;;
    esac
}

install_terminal "$@"
