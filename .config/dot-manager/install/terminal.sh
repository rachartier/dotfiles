#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

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
        # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
        if [ -d /tmp/ghostty ]; then
            log "info" "Removing old ghostty directory."
            rm -rf /tmp/ghostty
        fi

        git clone https://github.com/ghostty-org/ghostty
        cd ghostty || return 1
        __install_package_auto libgtk-4-dev libadwaita-1-dev libxml2-utils
        if command -v zig &>/dev/null; then
            log "info" "Zig is already installed."
        else
            wget https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz
            tar -xf zig-x86_64-linux-0.14.1.tar.xz
            sudo mv zig-x86_64-linux-0.14.1 /opt/zig-0.14.1
            sudo ln -sf /opt/zig-0.14.1/zig /usr/local/bin/zig
        fi

        if [ $(ldconfig -p | grep gtk4-layer-shell) ]; then
            log "info" "gtk4-layer-shell is already installed."
        else
            __install_package_auto meson ninja-build libwayland-dev wayland-protocols libgtk-4-dev gobject-introspection libgirepository1.0-dev gtk-doc-tools python3 valac
            meson setup build ninja -C build
            sudo ninja -C build install
            sudo ldconfig
        fi

        sudo snap install blueprint-compiler

        zig build -p "$HOME/.local" -Doptimize=ReleaseFast
        ;;
    esac
}

do_command() {
    local command="$1"
    shift
    local args=("$@")

    case "$command" in
    "install")
        install_terminal "${args[@]}"
        ;;
    *)
        log "error" "Unknown command: $command"
        return 1
        ;;
    esac
}

do_command "$@"
