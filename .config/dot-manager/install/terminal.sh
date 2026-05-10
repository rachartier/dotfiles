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
		cd /tmp/ghostty || return 1

		__install_package libgtk-4-dev libadwaita-1-dev libxml2-utils

		ZIG_VERSION="0.15.2"
		if ! command -v zig &>/dev/null || [[ "$(zig version 2>/dev/null)" != "$ZIG_VERSION" ]]; then
			print_step "Installing zig ${ZIG_VERSION}"
			wget -q "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
			tar -xf "zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
			sudo rm -rf "/opt/zig-${ZIG_VERSION}"
			sudo mv "zig-x86_64-linux-${ZIG_VERSION}" "/opt/zig-${ZIG_VERSION}"

			print_step "Creating symlink for zig"
			sudo ln -sf "/opt/zig-${ZIG_VERSION}/zig" /usr/local/bin/zig
		fi

		# if ! ldconfig -p | grep -q gtk4-layer-shell; then
		# 	__install_package meson ninja-build libwayland-dev wayland-protocols \
		# 		libgtk-4-dev gobject-introspection libgirepository1.0-dev \
		# 		gtk-doc-tools python3 valac
		# 	meson setup build ninja -C build
		# 	sudo ninja -C build install
		# 	sudo ldconfig
		# fi

		sudo snap install blueprint-compiler

		if zig build -p "$HOME/.local" -Doptimize=ReleaseFast -fno-sys=gtk4-layer-shell; then
			log "success" "ghostty installed in ~/.local/"
		else
			log "error" "ghostty build failed"
			return 1
		fi
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
