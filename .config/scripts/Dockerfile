FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV GIT_CLONE_METHOD=https
ENV LANG=en_US.UTF-8
ENV APPIMAGE_EXTRACT_AND_RUN=1

ARG USER_NAME
ARG USER_PASSWORD

RUN apt-get update \
	&& apt-get install -y curl sudo \
    && usermod -aG sudo "$USER_NAME"

# RUN echo "$USER_NAME:$USER_PASSWORD" | chpasswd

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

USER $USER_NAME
ENV TERM=xterm-256color

RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y

COPY ./first_install.sh /tmp/first_install.sh

ARG CACHEBUST=1
RUN sudo chmod +x /tmp/first_install.sh \
    && /tmp/first_install.sh

RUN sudo rm /tmp/first_install.sh


WORKDIR /home/$USER_NAME
RUN /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" submodule update --remote

RUN sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/mattmc3/antidote.git /home/$USER_NAME/.antidote \
    && zsh -c "/home/$USER_NAME/.config/scripts/dot.sh update"

# RUN sudo sed -i '/%sudo ALL=(ALL) NOPASSWD:ALL/d' /etc/sudoers
RUN zsh -c ". '$HOME/.antidote/antidote.zsh' && antidote load '${ZDOTDIR:-$HOME}/.zsh_plugins.txt'"

ENV TERM=wezterm
ENTRYPOINT ["/bin/zsh"]
