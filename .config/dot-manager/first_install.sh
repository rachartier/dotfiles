#!/bin/env bash

__echo_info() {
    echo "[INFO] $(tput setaf 6)$1"
    tput sgr 0
}

install_ubuntu_essentials() {
    sudo apt install -y -qq -o=Dpkg::Use-Pty=0 \
        git \
        wget \
        zsh \
        autotools-dev \
        coreutils \
        curl \
		jq

    sudo apt install -y -qq -o=Dpkg::Use-Pty=0 \
        automake \
        autoconf \
        build-essential \
        cmake
}

install_arch_essentials() {
    sudo pacman -S --noconfirm --needed \
        git \
        wget \
        zsh \
        base-devel \
        curl \
        jq

    sudo pacman -S --noconfirm --needed \
        automake \
        autoconf \
        cmake
}

install_dotfiles() {
    __echo_info "Configuring dotfiles"

    echo ".cfg" >>"$HOME"/.gitignore
    mkdir "$HOME"/.cfg

    if [ "$GIT_CLONE_METHOD" = "ssh" ]; then
        echo "Using SSH to clone dotfiles"
        git clone --bare git@github.com:rachartier/dotfiles.git "$HOME"/.cfg
    else
        echo "Using HTTPS to clone dotfiles"
        git clone --bare https://github.com/rachartier/dotfiles.git "$HOME"/.cfg
    fi

    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout -f
    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" reset --hard HEAD
    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" config --local status.showUntrackedFiles no
}

prepare_dotfiles() {
    __echo_info "Preparing dotfiles"

    echo 'source "$HOME/.dotfile_profile"' >>"$HOME/.profile"

    if [ ! -d "$HOME/.local/bin" ]; then
        __echo_info "Creating $HOME/.local/bin"
        mkdir -p "$HOME/.local/bin"
    fi

    dot_script_path="$HOME/.config/dot-manager/dot.sh"
    dot_script_link="$HOME/.local/bin/dot"

    if [ -L "$dot_script_link" ]; then
        __echo_info "Removing old dot symlink"
        rm "$dot_script_link"
    fi

    if [ ! -L "$dot_script_link" ] || [ ! -e "$dot_script_link" ]; then
        ln -s "$dot_script_path" "$dot_script_link"
    fi
}

# if [ "$(basename "$SHELL")" != "zsh" ]; then
#     __echo_info "Changing default shell to zsh"
#     chsh -s "$(which zsh)"
# fi

if [ -f /etc/arch-release ]; then
    __echo_info "Detected Arch Linux"
    install_arch_essentials
elif [ -f /etc/lsb-release ]; then
    __echo_info "Detected Ubuntu"
    install_ubuntu_essentials
else
    __echo_info "Unknown distribution, please install essentials manually."
    exit 1
fi

install_essentials
install_dotfiles
prepare_dotfiles

if [ -n "$DOTFILES_MINIMAL" ]; then
    "$HOME"/.config/dot-manager/dot.sh minimal
elif [ -n "$DOTFILES_DOCKER" ]; then
    "$HOME"/.config/dot-manager/dot.sh docker
else
    "$HOME"/.config/dot-manager/dot.sh init
    # "$HOME"/.config/dot-manager/dot.sh reinstall terminal
fi
