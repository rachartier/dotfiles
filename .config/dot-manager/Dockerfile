FROM ubuntu:24.04 AS builder

ARG USER_NAME
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG DEBIAN_FRONTEND=noninteractive

ENV DEBIAN_FRONTEND=noninteractive \
    GIT_CLONE_METHOD=https \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    APPIMAGE_EXTRACT_AND_RUN=1 \
    TERM=xterm-256color \
    PATH="/home/${USER_NAME}/.local/bin:${PATH}" \
    # Security settings
    DOCKER_CONTENT_TRUST=1 \
    # Disable history files
    HISTFILE=/dev/null

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    locales \
    sudo \
    zsh \
    && \
    # Generate locales
    locale-gen en_US.UTF-8 && \
    # Remove existing neovim if present
    apt-get remove -y neovim || true && \
    # Create user and group with handling for existing GID/UID
    if getent group ${GROUP_ID} > /dev/null 2>&1; then \
    existing_group=$(getent group ${GROUP_ID} | cut -d: -f1) && \
    groupmod -n ${USER_NAME} ${existing_group}; \
    else \
    groupadd -g ${GROUP_ID} ${USER_NAME}; \
    fi && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/zsh ${USER_NAME} 2>/dev/null || \
    usermod -l ${USER_NAME} $(id -un ${USER_ID}) && \
    # Setup sudo with restricted permissions
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME} && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

COPY --chown=${USER_NAME}:${USER_NAME} ./first_install.sh /tmp/first_install.sh

RUN sudo apt-get update && \
    chmod +x /tmp/first_install.sh && \
    /tmp/first_install.sh && \
    # Setup antidote
    git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote && \
    zsh -c ". '$HOME/.antidote/antidote.zsh' && antidote load '${ZDOTDIR:-$HOME}/.zsh_plugins.txt'" && \
    # Update dotfiles and git submodules
    /home/${USER_NAME}/.config/dot-manager/dot.sh update && \
    /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" submodule update --remote && \
    # Secure home directory
    chmod 700 /home/${USER_NAME} && \
    # Cleanup
    rm -f /tmp/first_install.sh

ENV TERM=wezterm
SHELL ["/bin/zsh", "-c"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD zsh -c 'ps aux | grep zsh | grep -v grep || exit 1'

CMD ["/bin/zsh"]
