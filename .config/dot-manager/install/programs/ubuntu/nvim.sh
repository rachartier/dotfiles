#!/bin/env bash

source "$DOT_MANAGER_DIR/helper.sh"

install_luarocks() {
	__install_package lua5.1 liblua5.1-dev

	cd /tmp || exit 1
	wget -nv -q https://luarocks.org/releases/luarocks-3.11.1.tar.gz &&
		tar zxpf luarocks-3.11.1.tar.gz &&
		cd luarocks-3.11.1 &&
		./configure >/dev/null 2>&1 && make >/dev/null 2>&1 && sudo make install >/dev/null 2>&1
}

install_treesitter() {
	local ts_version
	ts_version=$(__get_latest_release "tree-sitter/tree-sitter")

	__install_package_release "https://github.com/tree-sitter/tree-sitter/releases/download/$ts_version/tree-sitter-linux-x64.gz" "tree-sitter"
}

install_nvim() {
	print_step "Installing Neovim"
	local version=${1:-"stable"}

	sudo apt-get autoremove neovim -y >/dev/null 2>&1
	[ -f "$HOME/.local/bin/nvim" ] && rm "$HOME/.local/bin/nvim"

	log "download" "Downloading Neovim $version..."
	cd /tmp || exit 1
	wget -q "https://github.com/neovim/neovim/releases/download/$version/nvim-linux-x86_64.tar.gz" -O nvim-linux64.tar.gz >/dev/null

	sudo rm -rf /opt/nvim-linux-x86_64/
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	if [ ! -f "$HOME/.local/share/nvim/site/spell/fr.utf-8.spl" ]; then
		mkdir -p ~/.local/share/nvim/site/spell
		wget -q https://ftp.nluug.nl/pub/vim/runtime/spell/fr.utf-8.spl \
			-O ~/.local/share/nvim/site/spell/fr.utf-8.spl
	fi

	install_luarocks >/dev/null
	/opt/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" "+qall" >/dev/null 2>&1

	log "success" "Neovim $version installed in /opt/nvim-linux-x86_64/"
}

install_luarocks
install_treesitter
install_nvim "$@"
