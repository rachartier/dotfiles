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

    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.config/dot-manager/dot.sh" "$HOME/.local/bin/dot"
}

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

install_dotfiles
prepare_dotfiles

if [ -n "$DOTFILES_MINIMAL" ]; then
    "$HOME"/.config/dot-manager/dot.sh minimal
elif [ -n "$DOTFILES_DOCKER" ]; then
    "$HOME"/.config/dot-manager/dot.sh docker
else
    "$HOME"/.config/dot-manager/dot.sh init
fi
