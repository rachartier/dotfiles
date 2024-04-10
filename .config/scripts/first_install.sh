#!/bin/bash

sudo apt install -y -qq git

echo 'source "$HOME/.dotfile_profile"' >> "$HOME/.profile"

sudo apt install zsh --yes

cd /tmp || exit
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
yes | sh install.sh

echo ".cfg" >> "$HOME"/.gitignore
mkdir "$HOME"/.cfg

git clone --bare git@github.com:rachartier/dotfiles.git "$HOME"/.cfg

/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout
/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" reset --hard HEAD
/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" --local status.showUntrackedFiles no

sudo -E ~/.config/scripts/dot.sh init
