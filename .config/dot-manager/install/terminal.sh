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

		ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
		ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
		log "success" "kitty installed in ~/.local/kitty.app/"
		;;
	*)
		print_step "Installing ghostty"
		[ -d /tmp/ghostty ] && rm -rf /tmp/ghostty

		git clone https://github.com/ghostty-org/ghostty >>"$DOT_MANAGER_LOG" 2>&1
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

if [ "$1" = "install" ]; then
	install_terminal "$2"
else
	log "error" "Unknown command: $1"
	return 1
fi
