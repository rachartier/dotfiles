#!/bin/bash

__echo_info() {
    echo "[INFO] $(tput setaf 6)$1"
    tput sgr 0
}

install_essentials() {
    sudo apt install -y -qq -o=Dpkg::Use-Pty=0 git \
        wget \
        zsh
}

# install_ohmyzsh() {
#     __echo_info "Installing Oh My Zsh"
#     cd /tmp || exit
#     wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#     yes | sh install.sh
# }

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

    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout
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

    dot_script_path="$HOME/.config/scripts/dot.sh"
    dot_script_link="$HOME/.local/bin/dot"

    if [ ! -L "$dot_script_link" ] || [ ! -e "$dot_script_link" ]; then
        sudo ln -s "$dot_script_path" "$dot_script_link"
    fi
}

install_essentials
install_dotfiles
prepare_dotfiles

chsh -s "$(which zsh)"

if [ -n "$DOTFILES_MINIMAL" ]; then
    "$HOME"/.config/scripts/dot.sh minimal
elif [ -n "$DOTFILES_DOCKER" ]; then
    "$HOME"/.config/scripts/dot.sh docker
else
    "$HOME"/.config/scripts/dot.sh init
fi
