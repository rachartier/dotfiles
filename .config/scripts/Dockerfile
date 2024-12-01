FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive \
    GIT_CLONE_METHOD=https \
    LANG=en_US.UTF-8 \
    APPIMAGE_EXTRACT_AND_RUN=1 \
    TERM=xterm-256color

ARG USER_NAME
ARG USER_PASSWORD

RUN apt-get update && \
    apt-get install -y curl sudo git && \
    apt-get autoremove neovim -y && \
    usermod -aG sudo "$USER_NAME" && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER_NAME
RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

ARG CACHEBUST=5
COPY ./first_install.sh /tmp/first_install.sh
RUN sudo chmod +x /tmp/first_install.sh && \
    /tmp/first_install.sh && \
    sudo rm /tmp/first_install.sh

WORKDIR /home/$USER_NAME

RUN /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" submodule update --remote

RUN sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/mattmc3/antidote.git /home/$USER_NAME/.antidote && \
    zsh -c "/home/$USER_NAME/.config/scripts/dot.sh update" && \
    zsh -c ". '$HOME/.antidote/antidote.zsh' && antidote load '${ZDOTDIR:-$HOME}/.zsh_plugins.txt'"

ENV TERM=wezterm
ENTRYPOINT ["/bin/zsh"]
