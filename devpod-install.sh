#!/usr/bin/env bash

export DOTFILES_DOCKER=1
export GIT_CLONE_METHOD=https
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rachartier/dotfiles/main/.config/dot-manager/first_install.sh)"
