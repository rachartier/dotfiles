#!/bin/env bash

__echo_info() {
    echo "[INFO] $(tput setaf 6)$1"
    tput sgr 0
}

# duplicated from helper.sh: this runs before the dotfiles repo exists, so it can't source it
__append_once() {
    local file="$1" line="$2"
    grep -qxF -- "$line" "$file" 2>/dev/null || echo "$line" >>"$file"
}

install_ubuntu_essentials() {
    sudo apt install -y -qq -o=Dpkg::Use-Pty=0 \
        git \
        wget \
        zsh \
        coreutils \
        curl \
        jq \
        build-essential
}

install_dotfiles() {
    __echo_info "Configuring dotfiles"

    __append_once "$HOME/.gitignore" ".cfg"
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

    __append_once "$HOME/.profile" 'source "$HOME/.dotfile_profile"'

    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.config/dot-manager/dot.sh" "$HOME/.local/bin/dot"
}

install_ubuntu_essentials

install_dotfiles
prepare_dotfiles

if [ -n "$DOTFILES_MINIMAL" ]; then
    "$HOME"/.config/dot-manager/dot.sh minimal
elif [ -n "$DOTFILES_DOCKER" ]; then
    "$HOME"/.config/dot-manager/dot.sh docker
else
    "$HOME"/.config/dot-manager/dot.sh init
fi
