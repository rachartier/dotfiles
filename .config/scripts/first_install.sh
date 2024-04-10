#!/bin/bash

sudo apt install -y -qq git wget

echo 'source "$HOME/.dotfile_profile"' >> "$HOME/.profile"

sudo apt install zsh -y -qq

cd /tmp || exit
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
yes | sh install.sh

echo ".cfg" >> "$HOME"/.gitignore
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

if [ -n "$DOTFILES_MINIMAL" ]; then
    sudo -E ~/.config/scripts/dot.sh minimal
else
    sudo -E ~/.config/scripts/dot.sh init
fi

