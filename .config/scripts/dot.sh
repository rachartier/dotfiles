#!/bin/bash

__echo_success() {
	echo "[SUCCESS] $(tput setaf 2)$1"
	tput sgr 0
}

__echo_warning() {
	echo "[WARN] $(tput setaf 3)$1"
	tput sgr 0
}

__echo_info() {
	echo "[INFO] $(tput setaf 6)$1"
	tput sgr 0
}

__echo_failure() {
	echo >&2 "[FAILURE] $(tput setaf 1)$1"
	tput sgr 0
}

__need_sudo() {
	if [ "${EUID:-$(id -u)}" -eq 0 ]; then
		__echo_failure "Please run as root: sudo -E dot"
		exit
	fi
	eval $@
}

__get_latest_release() {
	curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

__is_pkg_installed() {
	local name="$1"

	dpkg-query -W --showformat='${Status}\n' "$name" 2>/dev/null | grep "install ok installed" >/dev/null
}

__install_appimage() {
	local url=$1
	local name=$2
	local filename

	filename=$(basename "$url" ".tar.gz")

	cd /tmp || exit 1
	wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
	chmod +x "$filename"
	mv "$filename" "$HOME/.local/bin/$name" && __echo_success "'$name' moved in $HOME/.local/bin/" || return 1
}

__install_package_release() {
	local url=$1
	local name=$2
	local filename

	filename=$(basename "$url")

    __echo_info "Downloading $filename"
	cd /tmp || exit 1
    echo $url
	wget -q "$url" && __echo_success "'$filename' downloaded." || return 1
	tar -xf "$filename" && __echo_success "$filename extracted." || return 1
	chmod +x "$name"
	mv "$name" "$HOME/.local/bin/$name" && __echo_success "'$name' moved in $HOME/local/bin/" || return 1
}

__install_zsh_plugin() {
	local url=$1
	local folder
	folder=$(echo "$url" | sed -r 's|.*/(.*)\.git$|\1|')

	local installation_folder="$HOME/.oh-my-zsh/custom/plugins/$folder"

	[ -d "$installation_folder" ] && rm -rf "$installation_folder"

	git clone "$url" "$installation_folder" && __echo_success "$folder installed." || return 1
}

__install_package_apt() {
	local pkg="$1"

	if __is_pkg_installed "$pkg"; then
		__echo_info "$pkg already installed."
	else
		apt install -y -qq "$pkg" && __echo_success "$pkg installed."
	fi
}

__make_symlink() {
	local path="$1"
	local oldname="$2"
	local oldname_path

	[ -f "$path" ] && rm -f "$path"

	oldname_path=$(which "$oldname")

	ln -s "$oldname_path" "$path"
}

__git_dot() {
	/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}

install_starship() {
	if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
		__echo_success "starship installed."
	else
		__echo_failure "starship not installed."
	fi
}

install_fzf() {
	if [ -d "$HOME/.fzf/" ]; then
		cd ~/.fzf || return 0
		git pull --quiet
		if yes | ./install; then
			__echo_success "fzf updated."
		else
			__echo_error "fzf not updated."
		fi
		return 0
	fi

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &>/dev/null
	yes | ~/.fzf/install
}

install_viu() {
	cd /tmp || exit 1
	wget -q "https://github.com/atanunq/viu/releases/download/v1.4.0/viu"
	chmod +x viu
	mv viu "$HOME"/.local/bin && __echo_success "viu installed."
}

install_lazygit() {
    LAZYGIT_VERSION=$(__get_latest_release "jesseduffield/lazygit")
	curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin && __echo_success "lazygit installed."
}

install_lazydocker() {
	curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

install_tmux() {
    __echo_info "Installing tmux"

	sudo apt install -qq libevent-dev yacc automake libncurses5-dev
	git clone https://github.com/tmux/tmux.git /tmp/tmux
	cd /tmp/tmux || exit
	sh autogen.sh
	./configure
	make && sudo make install

    # Install tmux plugin manager
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
}

install_bat() {
	__install_package_apt bat

    cd /tmp || exit
    git clone https://github.com/catppuccin/bat
	mkdir -p "$(bat --config-dir)/themes"

	cd bat || exit
	cp *.tmTheme "$(bat --config-dir)/themes"
	bat cache --build

	__make_symlink "$HOME/.local/bin/bat" batcat
}

install_packages() {
	__install_package_apt wget
	__install_package_apt libfuse2

	__install_package_apt python3.10-venv
	__install_package_apt nodejs
	__install_package_apt npm
	__install_package_apt unzip

	__install_package_apt ripgrep
	__install_package_apt fd-find
	__install_package_apt xsel
	__install_package_apt chafa

    if [ ! -v "$MINIMAL" ]; then
        install_bat
    fi

	__make_symlink "$HOME/.local/bin/fd" fdfind
}

install_zsh_plugins() {
	__install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions.git"
	__install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git"
	__install_zsh_plugin "https://github.com/b4b4r07/enhancd.git"
	__install_zsh_plugin "https://github.com/zsh-users/zsh-history-substring-search.git"

    if [ ! -v "$MINIMAL" ]; then
        __install_zsh_plugin "https://github.com/darvid/zsh-poetry.git"
    fi
}

install_nvim() {
	__install_appimage "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" nvim
	pip install pynvim
}

install_eza() {
	__install_package_release "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" eza
}

install_glow() {
	__install_package_release "https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_Linux_x86_64.tar.gz" glow
}


prepare_install() {
    if [ ! -d "$HOME/.local/bin" ]; then
        __echo_info "Creating $HOME/.local/bin"
        mkdir -p "$HOME/.local/bin"
    fi

    if [ -v "$MINIMAL" ]; then
        echo "export MINIMAL=1" >> "$HOME/.dotfile_profile"
    fi
}

install_essentials() {
    prepare_install

	install_tmux
	install_packages
	install_zsh_plugins
	install_nvim

	install_eza
	install_glow

	install_fzf
	install_viu
	install_lazygit
	install_lazydocker
	install_starship
}

install_minimal() {
    prepare_install

    install_packages
    install_zsh_plugins
    install_nvim

    install_eza
    install_fzf
    install_viu
    install_starship
}

do_reinstall() {
	case "$1" in
	"tmux") install_tmux ;;
	"nvim") install_nvim ;;
	"packages") install_packages ;;
	"zsh") install_zsh_plugins ;;
	"fzf") install_fzf ;;
	"viu") install_viu ;;
	"eza") install_eza ;;
	"glow") install_glow ;;
	"lazygit") install_lazygit ;;
	"lazydocker") install_lazydocker ;;
	"starship") install_starship ;;
	"all") install_essentials ;;
    "minimal") install_minimal ;;
	*) install_essentials ;;
	esac
}

do_command() {
	case "$1" in
	"init") install_essentials ;;
    "minimal") install_minimal ;;
	"reinstall") do_reinstall "$2" ;;
	*) __git_dot "$@" ;;
	esac
}


if [ -v "$MINIMAL" ]; then
    __echo_info "Installing minimal setup"
    install_minimal
    exit
fi

if [ $# -eq 0 ]; then
	__git_dot "$@"
else
	do_command "$@"
fi
