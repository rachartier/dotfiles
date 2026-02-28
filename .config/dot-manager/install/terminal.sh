#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_terminal() {
	local terminal_name="$1"

	cd /tmp || exit 1
	case "$terminal_name" in
	"wezterm")
		print_step "Installing wezterm"
		__download_install_deb https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu24.04.deb wezterm
		;;
	"kitty")
		print_step "Installing kitty"
		curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

		[ -L "$HOME/.local/bin/kitty" ] && rm "$HOME/.local/bin/kitty"
		[ -L "$HOME/.local/bin/kitten" ] && rm "$HOME/.local/bin/kitten"

		ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
		ln -s ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
		log "success" "kitty installed in ~/.local/kitty.app/"
		;;
	*)
		print_step "Installing ghostty"
		[ -d /tmp/ghostty ] && rm -rf /tmp/ghostty

		git clone https://github.com/ghostty-org/ghostty >/dev/null 2>&1
		cd ghostty || return 1

		__install_package libgtk-4-dev libadwaita-1-dev libxml2-utils

		if ! command -v zig &>/dev/null; then
			wget -q https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz
			tar -xf zig-x86_64-linux-0.14.1.tar.xz
			sudo mv zig-x86_64-linux-0.14.1 /opt/zig-0.14.1
			sudo ln -sf /opt/zig-0.14.1/zig /usr/local/bin/zig
		fi

		if ! ldconfig -p | grep -q gtk4-layer-shell; then
			__install_package meson ninja-build libwayland-dev wayland-protocols \
				libgtk-4-dev gobject-introspection libgirepository1.0-dev \
				gtk-doc-tools python3 valac
			meson setup build ninja -C build
			sudo ninja -C build install
			sudo ldconfig
		fi

		sudo snap install blueprint-compiler

		zig build -p "$HOME/.local" -Doptimize=ReleaseFast
		log "success" "ghostty installed in ~/.local/"
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
